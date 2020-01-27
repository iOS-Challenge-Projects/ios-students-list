//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

enum SortOptions: Int {
    case firstName
    case lastName
}

enum TrackType: Int {
    case none
    case iOS
    case Web
    case UX
}

class StudentController {
    
    private var students: [Student] = []
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    //Returning Void means that it will return nothing
    func loadFromPersistentStore(completition: @escaping ([Student]?, Error?) -> Void){
        
        //Use to run the code Concurrently by not running in the main queue
        let bgQueue = DispatchQueue(label: "studentQueue", attributes: .concurrent)
        
        //here use pass in the closure the process to the queue
        //Running async to present the app from becoming unresponsive in the main queue
        
        bgQueue.async {
            
            let fm = FileManager.default
            guard let url = self.persistentFileURL,
                fm.fileExists(atPath: url.path) else {return}
            
            do {
                
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                
                let studentsData = try decoder.decode([Student].self, from: data)
                
                self.students = studentsData
                
                completition(self.students, nil)
                
            } catch {
                print("Error loading student data: \(error)")
                completition(nil, error)
            }
        }
    }
    
    
    //Filter function
    func filter(with trackType: TrackType, sortedBy sorter: SortOptions, completion: @escaping ([Student]) -> Void) {
        var updateStudents: [Student]
        
        switch trackType {
        case .iOS:
            //$0 is the current index
            updateStudents = students.filter {$0.course == "iOS"}
        case .Web:
            //$0 is the current index
            updateStudents = students.filter {$0.course == "Web"}
        case .UX:
            //$0 is the current index
            updateStudents = students.filter {$0.course == "UX"}
        default://This includes the .none
            updateStudents = students
        }
        
        if sorter == .firstName {
            //Here we compares the current element to the next element
            updateStudents = updateStudents.sorted{ $0.firstName < $1.firstName }
        }else{
            updateStudents = updateStudents.sorted{ $0.lastName < $1.lastName}
        }
        
        //Now we return the results using the completion
        
        completion((updateStudents))
    }
}
