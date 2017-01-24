//
//  Checklist.swift
//  CheckLists
//
//  Created by ginger on 2017/1/16.
//  Copyright © 2017年 ginger. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    //for loading the objects from the plist file
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
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    //计算CheckList中未完成的ChecklistItem数
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    //sort items in a checklist
    func sortChecklists() {
        //lists.sort(by: {checklist1,checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending})
        items.sort(by: {
            checklistitem1,checklistitem2 in checklistitem1.dueDate < checklistitem2.dueDate
        })
    }
}
