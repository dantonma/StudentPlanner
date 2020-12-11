//
//  AssignmentTableViewController.swift
//  Student Planner
//
//  Created by Marissa D'Antonio on 12/11/20.
//

import UIKit

class AssignmentTableViewController: UITableViewController {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var assignmentText: UITextField!
    @IBOutlet weak var classText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesText: UITextView!
    
    var assignmentItem: AssignmentItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if assignmentItem == nil {
            assignmentItem = AssignmentItem(name: "", clas: "", date: Date(), notes: "")
        }
        
        assignmentText.text = assignmentItem.name
        classText.text = assignmentItem.clas
        datePicker.date = assignmentItem.date
        notesText.text = assignmentItem.notes
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        assignmentItem = AssignmentItem(name: assignmentText.text!, clas: classText.text!, date: datePicker.date, notes: notesText.text)
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
