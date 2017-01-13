//
//  ChecklistItem.swift
//  CheckLists
//
//  Created by ginger on 2017/1/10.
//  Copyright © 2017年 ginger. All rights reserved.
//

import Foundation

//继承了NSObject使之成为equitable的object（可做==运算，可通过index(of)方法求索引）
//遵从了NSCoding protocol to use the NSCoder system on an object
class ChecklistItem: NSObject ,NSCoding {

    //properties
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
    //the method for unfreezing the objects from the file.
    required init?(coder aDecoder: NSCoder) {
        //do the opposite from encode(with). You take objects from the NSCoder’s decoder object and put their values inside your own properties.
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    //改变 √ 的状态
    func toggleChecked() {
        checked = !checked
    }
}
