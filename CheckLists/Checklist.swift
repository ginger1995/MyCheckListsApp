//
//  Checklist.swift
//  CheckLists
//
//  Created by ginger on 2017/1/16.
//  Copyright © 2017年 ginger. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
