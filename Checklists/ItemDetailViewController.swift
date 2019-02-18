//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Deniz Gelir on 1/25/19.
//  Copyright © 2019 Deniz Gelir. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
   
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem)
    
}

class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    
    weak var delegate: ItemDetailViewControllerDelegate?
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    var itemToEdit : ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
           title = "Edit Item"
           textField.text = item.text
           doneBarButton.isEnabled = true
        }
    }
    
    
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }
        else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        if newText.count > 0 {
            doneBarButton.isEnabled = true
        } else {
            doneBarButton.isEnabled = false
        }
        return true
    }
    
    
}
