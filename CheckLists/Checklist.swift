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
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    init(name: String) {
        self.name = name
        super.init()
    }
    //计算CheckList中未完成的ChecklistItem数
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
