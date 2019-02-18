//
//  ViewController.swift
//  Checklists
//
//  Created by Deniz Gelir on 1/20/19.
//  Copyright © 2019 Deniz Gelir. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController,ItemDetailViewControllerDelegate {
    
    var checklist : Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",for: indexPath)
        let item = checklist.items[indexPath.row]

        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
           let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func configureCheckmark(for cell: UITableViewCell,with indexPath: IndexPath) {
       
        let item = checklist.items[indexPath.row]
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        
        if item.checked {
            label.text = "√"
        }
       else {
         label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //Rowlar her zaman indexPath ile tutulur!!UNUTMA!!
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        //yeni item olusturup data modele ekledik
        let newRowIndex = checklist.items.count
        let item = ChecklistItem()
        item.text = "I'm a new row"
        item.checked = false
        checklist.items.append(item)
        //sonra yeni row olusturup tableview'a ekledik
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexpaths = [indexPath]
        tableView.insertRows(at: indexpaths, with: .automatic)
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //once data modelden sildik
        checklist.items.remove(at: indexPath.row)
        //sonra tableview'dan row'u sildik
        let indexpaths = [indexPath]
        tableView.deleteRows(at: indexpaths, with: .automatic)
     
    }

    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
       
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        if segue.identifier == "AddItem" {
            // 2
            let navigationController = segue.destination as! UINavigationController
                // 3
            let controller = navigationController.topViewController as! ItemDetailViewController
            // 4
            controller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    
    
    
    
}

