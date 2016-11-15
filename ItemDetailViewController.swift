//
//  ItemDetailViewController.swift
//  Checklist
//
//  Created by Yingcai Dong on 2016-09-03.
//  Copyright © 2016 Yingcai Dong. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: checklistItem)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: checklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    // if user want to edite checklist item, then this variable will be initialized
    var itemToEdit: checklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
        }
    }
    
    // when the textField appears, pop up the keyboard.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!
            
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
            
        } else {
            let item = checklistItem()
            item.text = textField.text!
            item.checked = false
            
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }
    
    // disable the done button when init nothing put in the textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let initString: NSString = textField.text! as NSString
        doneBarButton.isEnabled = (initString.length>0)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldTextString:NSString = textField.text! as NSString
        let newTextString:NSString = oldTextString.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newTextString.length > 0)
        
        return true
    }
    
}
