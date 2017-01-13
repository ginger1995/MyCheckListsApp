//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Matthijs on 05/07/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject ,NSCoding {//继承了NSObject使之成为equitable的object（可做==运算）
    
    var text = ""
    var checked = false
    
    override init() {
        super.init()
    }
    
    //When NSKeyedArchiver tries to encode the ChecklistItem object it will send the checklist item an encode(with) message.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
