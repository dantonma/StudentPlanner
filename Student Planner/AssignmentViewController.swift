//
//  ViewController.swift
//  Student Planner
//
//  Created by Marissa D'Antonio on 12/11/20.
//

import UIKit
import AVFoundation

class AssignmentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var assignmentItems: [AssignmentItem] = []
    var audioPlayer: AVAudioPlayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("assignments").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            assignmentItems = try jsonDecoder.decode(Array<AssignmentItem>.self, from: data)
            tableView.reloadData()
        } catch {
            print("error")
        }
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("assignments").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(assignmentItems)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! AssignmentTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.assignmentItem = assignmentItems[selectedIndexPath.row]
        }
    }
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! AssignmentTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            assignmentItems[selectedIndexPath.row] = source.assignmentItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
//        } else {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                tableView.deselectRow(at: selectedIndexPath, animated: true)
//            }
        } else {
            let newIndexPath = IndexPath(row: assignmentItems.count, section: 0)
            assignmentItems.append(source.assignmentItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveData()
    }
    
    
    func playSound(name:String) {
        if let sound = NSDataAsset (name: name) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("error")
            }
        } else {
            print("error")
        }
    }
    
    @IBAction func reassuranceButtonPressed(_ sender: UIBarButtonItem) {
        playSound(name: "cheers")
    }
    
    @IBAction func motivationButtonPressed(_ sender: UIBarButtonItem) {
        playSound(name: "woo")
    }
    
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
}

extension AssignmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = assignmentItems[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            assignmentItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        saveData()
    }
    
    
}
