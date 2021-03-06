//
//  DataModel.swift
//  Checklists
//
//  Created by Deniz Gelir on 2/14/19.
//  Copyright © 2019 Deniz Gelir. All rights reserved.
//

import Foundation

class DataModel {
  
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }

    var lists = [Checklist]()
    
    var indexOfSelectedChecklist : Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    // this method is now called saveChecklists()
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        // this line is different from before
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    // this method is now called loadChecklists()
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            // this line is different from before
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            sortChecklists()
        } }

    func registerDefaults() {
        let dictionary: [String: Any] = [ "ChecklistIndex": -1 ,
                                          "FirstTime":true]
        UserDefaults.standard.register(defaults: dictionary)
    }

    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List", iconName: "No Icon")
                lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false,forKey:"FirstTime")
            userDefaults.synchronize()
        }
    }
    
    //sorting algorithym
    func sortChecklists() {
        lists.sort(by: {checklist1,checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
    }
    
}


