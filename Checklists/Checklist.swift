//
//  Checklist.swift
//  Checklists
//
//  Created by Deniz Gelir on 2/1/19.
//  Copyright © 2019 Deniz Gelir. All rights reserved.
//

import UIKit

class Checklist: NSObject,NSCoding {

    var iconName : String
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String,iconName: String){
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
       return count
    }
    
    
    
}
