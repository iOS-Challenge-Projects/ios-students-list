//
//  Student.swift
//  Students
//
//  Created by Andrew R Madsen on 8/5/18.
//  Copyright © 2018 Lambda Inc. All rights reserved.
//

import Foundation

struct Student: Codable {
    var name: String
    var course: String
    var firstName: String {
        //split return a substring so we turn it back into a string
        return String(name.split(separator: " ")[0])
    }
    
    var lastName: String {
        return String(name.split(separator: " ")[1])
    }
}
