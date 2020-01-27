//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let studentController = StudentController()
    //We can use a did set in order that as soon as the value changes we run some code
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
//MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        studentController.loadFromPersistentStore { students, error in
            if let error = error {
                print("Error loading studens \(error)")
                return // to end the process
            }
            
            //since we are running the request not in the main queue
            //once the process completes we need to set the UI in the main queue
            //since this is related to the UIKit
            DispatchQueue.main.async {
                if let students = students {
                    self.filteredAndSortedStudents = students
                }
            }
        }
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    // MARK: - Private
    
    private func updateDataSource() {
        let sort = SortOptions(rawValue: sortSelector.selectedSegmentIndex) ?? .firstName
        
        let filter = TrackType(rawValue: filterSelector.selectedSegmentIndex) ?? .none
        
        studentController.filter(with: filter, sortedBy: sort) { students in
            self.filteredAndSortedStudents = students
        }
    }
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        // Configure cell
        let SingleStudent = filteredAndSortedStudents[indexPath.row]
        cell.textLabel?.text = SingleStudent.name
        cell.detailTextLabel?.text = SingleStudent.course
        
        return cell
    }
}
