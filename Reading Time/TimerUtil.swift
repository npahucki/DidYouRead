//
//  TimerUtil.swift
//  Reading Time
//
//  Created by Julian Porta on 5/15/15.
//  Copyright (c) 2015 Julian Porta. All rights reserved.
//

class TimerUtil {

    class func scheduleOneHourReminder (){
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        components.hour++
        let oneHourFromNow = calendar.dateFromComponents(components)
        
        createReminderAndCancelPrevious(oneHourFromNow!, repeat: nil)
    }
    
    class func scheduleTodayOrTomorrowReminder() {
        // If before 7 pm , schedule for today, else tomorrow
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour, fromDate: date)
        if(components.hour < 19) {
            // Today
            components.hour = 19
        } else {
            // Tomorrow
            components.hour = 19
            components.day++
        }
        
        let atSeven = calendar.dateFromComponents(components)
        createReminderAndCancelPrevious(atSeven!, repeat: NSCalendarUnit.CalendarUnitDay)
        
    }

    class func scheduleTomorrowReminder (){
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        components.hour = 19
        components.day++
        let tomorrowAtSeven = calendar.dateFromComponents(components)
        
        createReminderAndCancelPrevious(tomorrowAtSeven!, repeat: NSCalendarUnit.CalendarUnitDay)
        
    }
    
    private class func createReminderAndCancelPrevious (fireDate : NSDate, repeat : NSCalendarUnit?) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        var dailyNotification: UILocalNotification = UILocalNotification()
        dailyNotification.alertAction = "Reading Time!"
        dailyNotification.alertBody = "Did you read to your child today?"
        dailyNotification.fireDate = fireDate
        if let unit = repeat {
            dailyNotification.repeatInterval = unit
        }
        UIApplication.sharedApplication().scheduleLocalNotification(dailyNotification)
    }
    
}