//
//  Reading.swift
//  Reading Time
//
//  Created by Julian Porta on 5/12/15.
//  Copyright (c) 2015 Julian Porta. All rights reserved.
//

public class Reading: PFObject, PFSubclassing {
    
    public class func parseClassName() -> String {
        return "Reading"
    }
    
    @NSManaged public var kid : Kid
    @NSManaged public var readingTime: NSNumber
    @NSManaged public var readingType: String?
    
    
}		