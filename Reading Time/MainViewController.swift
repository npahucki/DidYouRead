//
//  MainViewController.swift
//  Reading Time
//
//  Created by Julian Porta on 5/7/15.
//  Copyright (c) 2015 Julian Porta. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var howLongLabelTest: UILabel!
    @IBOutlet weak var howLongSlider: UISlider!
    
    @IBAction func howLongSliderValueChange(sender: UISlider) {
        sender.setValue(round(sender.value), animated: true)
        var currentValue = Int(sender.value)
        howLongLabelTest.text = howLongPickerData[currentValue]
    }
    
    
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var howLongLabel: UILabel!
    @IBOutlet weak var whatDidLabel: UILabel!
    @IBOutlet weak var howLongPicker: UIPickerView!
    @IBOutlet weak var whatDidPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var doneViewLabel: UILabel!
    
    
    let howLongPickerData = [
        "No, I can't today",
        "No, ask me in an hour",
        "Yes, for less 15 minutes",
        "Yes, for 15-30 minutes",
        "Yes, for 30-60 minutes",
        "Yes, for more than 60 minutes"
    ]
    let whatDidPickerData = [
        "Picture Book",
        "Children Storybook",
        "Novel",
        "Newspaper / Magazine",
        "Other"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var showDoneView = false
        
        if let lastNotedReading = NSUserDefaults.standardUserDefaults().objectForKey("lastNotedReadingDate") as? NSDate {
            showDoneView = lastNotedReading.isSameDayAsToday()
        }

//        doneView.hidden = true
//        recordView.hidden = true
//        testView.hidden = false
        doneView.hidden = !showDoneView
        recordView.hidden = showDoneView
        
        if Installation.currentInstallation().kid == nil {
            performSegueWithIdentifier("showConfiguration", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let kidVC = segue.destinationViewController as? KidViewController {
            if let kid = Installation.currentInstallation().kid {
                kidVC.kid = kid
            } 
        }
    }

    
    @IBAction func didTouchSave(sender: AnyObject) {
        
        let reading = Reading()
        
        reading.readingTime = howLongPicker.selectedRowInComponent(0)
        reading.readingType = whatDidPickerData[ whatDidPicker.selectedRowInComponent(0) ]
        reading.kid = Installation.currentInstallation().kid!
        reading.saveEventually() // WithBlock(block : { (result : Boolean , error : NSError?) in

        // Assing self.reading to something so we can ask later for the last reading
        if reading.readingTime == 1 {
            doneViewLabel.text = "We'll remind you in an hour"
            TimerUtil.scheduleOneHourReminder()
        } else {
            if reading.readingTime == 0 {
                doneViewLabel.text = "No problem, we'll ask you again tomorrow"
            }
            else {
                doneViewLabel.text = "Well done, we'll ask you again tomorrow"
            }
            
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "lastNotedReadingDate")
            TimerUtil.scheduleTomorrowReminder()
        }
        
        doneView.hidden = false
        recordView.hidden = true
    }
    
    // MARK: - UIPickerViewDataSource Implementation
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == howLongPicker {
            return howLongPickerData.count
        } else if pickerView == whatDidPicker {
            return whatDidPickerData.count
        } else {
            assert(false, "Unexpected pickerView \(pickerView)")
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == howLongPicker {
            return howLongPickerData[row]
        } else if pickerView == whatDidPicker {
            return whatDidPickerData[row]
        } else {
            assert(false, "Unexpected pickerView \(pickerView)")
            return ""
        }
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
