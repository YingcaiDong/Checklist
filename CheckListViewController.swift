//
//  ViewController.swift
//  Checklist
//
//  Created by Yingcai Dong on 2016-09-02.
//  Copyright © 2016 Yingcai Dong. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, ItemDetailViewControllerDelegate {

    // init an object
    // prepare for the sender from AllListViewController
    var checklist: Checklist!
    //var checklist = Checklist!(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make the checklist page change different title
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //===========================
    //      view logic
    //===========================
    
    //1. fetch number of rows in the selected section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    //2. load content to cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // identifer defined in the cell of the storyboard for this controller
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    //3. tell what cell should perform after press
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // delete one selected item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    
    //==========================
    //      other funciton
    //==========================
    func configureTextForCell(_ cell: UITableViewCell, withChecklistItem item: checklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmarkForCell(_ cell: UITableViewCell, withChecklistItem item: checklistItem) {
        let checkmark = cell.viewWithTag(1001) as! UILabel
        checkmark.textColor = view.tintColor
        if item.checked {
            checkmark.text = "✔︎"
        } else {
            checkmark.text = ""
        }
    }
    
    //=========================
    // the delegate function
    //=========================
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        // close the window when press cancel button
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: checklistItem) {
        
        // increase row number by one
        let newRowIndex = checklist.items.count
        
        // store incomming data 'item' to the file
        checklist.items.append(item)
        
        // get the increased indexPath and insert to the tableView
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        // close the window when press done button
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: checklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            // controller -> ItemDetailViewController, in other words, B
            // self -> CheckListViewController, in other words, A
            // B.delegate = A
            // CheckListViewController 作为 ItemDetailViewController 的 delegate
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
}

