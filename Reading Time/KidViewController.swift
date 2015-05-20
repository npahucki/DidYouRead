//
//  KidViewController.swift
//  Reading Time
//
//  Created by Julian Porta on 5/7/15.
//  Copyright (c) 2015 Julian Porta. All rights reserved.
//

import UIKit

class KidViewController: UIViewController {

    var kid : Kid!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var kidNameTextField: UITextField!
    
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    @IBOutlet var kidView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFInstallation.currentInstallation() // THIS IS A NOOP DUMMY THAT IS NEEDED TO BE ABLE TO CALL THE CORRECT CONSTRUCTOR ON Kid()
        birthDatePicker.maximumDate = NSDate()
        
        if kid != nil {
            kid.fetchIfNeededInBackgroundWithBlock({ (populatedKid : PFObject?, err : NSError?) -> Void in
                if let localPopulatedKid = populatedKid as? Kid {
                    self.kid = localPopulatedKid
                    self.kidNameTextField.text = localPopulatedKid.name
                    self.birthDatePicker.date = localPopulatedKid.birthDate
                } else {
                    self.kid = Kid()
                    self.kid.birthDate = NSDate()
                }
            })
        } else {
            kid = Kid()
            kid.birthDate = NSDate()
        }
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "networkReachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func networkReachabilityChanged(notification : NSNotification){
        
        let reachability = notification.object as! Reachability
        let reachable = reachability.currentReachabilityStatus() != NetworkStatus.NotReachable
        doneButton.enabled = reachable
        println("reachability changed")
        
        if !reachable {
            UIAlertView(title: "No internet connection", message: "To add or edit your child have to have an internet connection", delegate: nil, cancelButtonTitle: "Ok").show()
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        doneButton.enabled = Reachability.isParseCurrentlyReachable()
        
    }
    
    @IBAction func didTouchDoneButton(sender: AnyObject) {

        let loadingNotification = MBProgressHUD.showHUDAddedTo(kidView, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Saving"
        
        doneButton.enabled = false
        kid.name = kidNameTextField.text
        kid.birthDate = birthDatePicker.date
        if kid.isDirty() {
            kid.saveInBackground().continueWithExecutor(BFExecutor.mainThreadExecutor(), withSuccessBlock: { (kidSaveTask : BFTask!) -> AnyObject! in
                Installation.currentInstallation().kid = self.kid
                return Installation.currentInstallation().saveInBackground()
            }).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { (installSaveTask : BFTask!) -> AnyObject! in
                self.doneButton.enabled = true
                // TODO: Change this!
                if let error = installSaveTask.error {
                    println("Could not save installation or child. Error \(error)")
                }
                else {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                MBProgressHUD.hideAllHUDsForView(self.kidView, animated: true)
                return nil
            })
        }
    }
    
    //

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
