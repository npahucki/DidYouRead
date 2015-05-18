//
//  Device.swift
//  Reading Time
//
//  Created by Julian Porta on 5/8/15.
//  Copyright (c) 2015 Julian Porta. All rights reserved.
//

public class Kid: PFObject, PFSubclassing {
    
    public class func parseClassName() -> String {
        return "Kid"
    }
    
    @NSManaged public var name: String!
    @NSManaged public var birthDate: NSDate!

}