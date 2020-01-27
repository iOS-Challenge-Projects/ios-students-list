//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

class StudentController {
    
    private var students: [Student] = []
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    //Returning Void means that it will return nothing
    func loadFromPersistentStore(completition: @escaping ([Student]?, Error?) -> Void){
        let fm = FileManager.default
        guard let url = self.persistentFileURL,
            fm.fileExists(atPath: url.path) else {return}
        
        do {
            
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            
            let students = try decoder.decode([Student].self, from: data)
            
            self.students = students
            
            completition(students, nil)
            
        } catch {
            print("Error loading student data: \(error)")
            completition(nil, error)
        }
        
    }
}
