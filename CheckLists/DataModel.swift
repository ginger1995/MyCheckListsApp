//
//  DataModel.swift
//  CheckLists
//
//  Created by ginger on 2017/1/18.
//  Copyright © 2017年 ginger. All rights reserved.
//

import Foundation
//本类专一负责文件的存储与读取（工具类）
class DataModel {
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    //UserDefaults will use the values from this dictionary if you ask it for a key but it cannot find anything under that key.
    func registerDefaults() {
        let dictionary: [String: Any] = [ "ChecklistIndex": -1, "FirstTime": true ]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let isFirstTime = UserDefaults.standard.bool(forKey: "FirstTime")
        if isFirstTime {
            let checklist = Checklist(name: "ExampleList")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: "FirstTime")
            UserDefaults.standard.synchronize()
        }
    }
    //sort
    func sortChecklists() {
        //lists.sort(by: {checklist1,checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending})
        lists.sort(by: {
            checklist1,checklist2 in checklist1.name.lowercased() < checklist2.name.lowercased()
        })
    }
    
    //get the full path to the Documents folder.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    //construct the full path to the file that will store the checklist items.
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    //call this saveChecklists() method whenever the list of items is modified.
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    //do the work of loading the .plist file.
    func loadChecklists() {
        let path = dataFilePath()
        //Try to load the contents of Checklists.plist into a new Data object.
        if let data = try? Data(contentsOf :path) {
            //create an NSKeyedUnarchiver object (note: this is an unarchiver) and ask it to decode that data into the items array. This populates the array with exact copies of the ChecklistItem objects that were frozen into this file.
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            sortChecklists()
        }
    }
    
}
