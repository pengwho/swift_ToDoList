//
//  ViewController.swift
//  todolist_ver2
//
//  Created by Alice on 2019/12/29.
//  Copyright © 2019 Alice. All rights reserved.
//

import UIKit
import Foundation

protocol ListTableViewCellDelegate {
    func ListTableViewCellTapCheckBoxButton(_ sender: ListTableViewCell)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListTableViewCellDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
    var taskData: [myTask] = []
    
    var checkBoxDics: [Bool:UIImage] = [true: UIImage(named: "icon_checkbox_white")!,
                                        false: UIImage(named: "icon_uncheckbox_white")!]
    
    struct myTask {
        var isCheck: Bool = false
        var priorityID: Int = 0
        var task: String = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.dataSource = self
        listTableView.delegate = self
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        listTableView.setEditing(editing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            print("adding new task !")
        case "EditItem":
            print("Editing some task !")
            guard let writerVC = segue.destination as? WriterViewController else { return }
            guard let selectedCell = sender as? ListTableViewCell else { return }
            guard let indexPath = listTableView.indexPath(for: selectedCell) else { return }
            let selectedText = taskData[indexPath.row].task
            writerVC.textSendForVC = selectedText
            writerVC.textIndexSendForVC = indexPath.row
        case "GoInfoPage":
            print("GoInfoPage !")
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func didUnwindFromWriterVC(_ sender: UIStoryboardSegue) {
        if let writerVC = sender.source as? WriterViewController {
            let textMessage: String = writerVC.TaskEditTextField.text
            addTask(indexPath: writerVC.textIndexSendForVC!, textMessage: textMessage)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let taskIndexPath = taskData[indexPath.row]
        cell.taskLabel?.text = taskIndexPath.task
        cell.checkButton?.setBackgroundImage(checkBoxDics[taskIndexPath.isCheck], for: UIControl.State.normal)
        
        cell.delegate = self
        return cell
    }
    
    // MARK: Tableview delegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case UITableViewCell.EditingStyle.delete:
            taskData.remove(at: indexPath.row)
            listTableView.reloadData()
        default:
            break
        }
    }
    
    func addTask( indexPath: Int, textMessage: String ) {
        if textMessage == "" {
            return
        }
        else {
            if indexPath == -1 {
                taskData.append(myTask(isCheck: false, priorityID: 0, task: textMessage))
                saveData()
                listTableView.reloadData()
                return
            }
            else {
                taskData[indexPath].task = textMessage
                saveData()
                listTableView.reloadData()
                return
            }
        }
    }
    
    func saveData() {
        let uDef = UserDefaults.standard
        let myTaskDics = taskData.map{(myTask) -> [String:Any] in
            return ["isCheck": myTask.isCheck, "priorityID": myTask.priorityID, "task": myTask.task]
        }
        uDef.set(myTaskDics, forKey: "taskData")
    }
    
    func loadData() {
        let uDef = UserDefaults.standard
        if let taskData = uDef.array(forKey: "taskData") as? [[String:Any]] {
            self.taskData = taskData.compactMap({ myTaskDics -> myTask? in
                if let isCheck = myTaskDics["isCheck"] as? Bool,
                    let priorityID = myTaskDics["priorityID"] as? Int,
                    let task = myTaskDics["task"] as? String {
                    return myTask( isCheck: isCheck, priorityID: priorityID, task: task)
                }else {
                    return nil
                }
            })
        }
    }
    
    func ListTableViewCellTapCheckBoxButton(_ sender: ListTableViewCell) {
        guard let tappedIndexPath = listTableView.indexPath(for: sender) else { return }
        // var taskIndexPath = taskData[tappedIndexPath.row]
        if taskData[tappedIndexPath.row].isCheck {
            taskData[tappedIndexPath.row].isCheck = false
        }else {
            taskData[tappedIndexPath.row].isCheck = true
        }
        listTableView.reloadData()
    }

}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    
    var delegate: ListTableViewCellDelegate?
    
    @IBAction func TapCheckButton(_ sender: Any) {
        delegate?.ListTableViewCellTapCheckBoxButton(self)
    }
    
}
