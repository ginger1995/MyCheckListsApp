//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Matthijs on 05/07/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {//继承了NSObject使之成为equitable的object（可做==运算）
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
