//
//  DateUtil.swift
//  Reading Time
//
//  Created by Julian Porta on 5/15/15.
//  Copyright (c) 2015 Julian Porta. All rights reserved.
//

extension NSDate {

    func isSameDayAsToday() -> Bool{
        let against = self
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        let todayComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: today)
        let againstComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: against)
        
        return (todayComponents.year == againstComponents.year && todayComponents.month == againstComponents.month && todayComponents.day == againstComponents.day)
    }
}
