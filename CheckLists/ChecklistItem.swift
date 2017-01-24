//
//  ChecklistItem.swift
//  CheckLists
//
//  Created by ginger on 2017/1/10.
//  Copyright © 2017年 ginger. All rights reserved.
//

import Foundation
import UserNotifications

//继承了NSObject使之成为equitable的object（可做==运算，可通过index(of)方法求索引）
//遵从了NSCoding protocol to use the NSCoder system on an object
class ChecklistItem: NSObject ,NSCoding {

    //properties
    var text = ""
    var checked = false
    var dueDate = Date() //Returns a `Date` initialized to the current date and time.
    var shouldRemind = false
    var itemID: Int
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        self.itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    convenience init(text: String) {
        self.init(text: text, checked: false)
    }
    
    //When NSKeyedArchiver tries to encode the ChecklistItem object it will send the checklist item an encode(with) message.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    //the method for unfreezing the objects from the file.
    required init?(coder aDecoder: NSCoder) {
        //do the opposite from encode(with). You take objects from the NSCoder’s decoder object and put their values inside your own properties.
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    //改变 √ 的状态
    func toggleChecked() {
        checked = !checked
    }
    
    //为每个ChecklistItem计划通知
    func scheduleNotification() {
        //每次设置新的Notification时先移除旧的
        removeNotification()
        
        if shouldRemind && (dueDate > Date()) {
            //1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            //2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month,.day,.hour,.minute], from: dueDate)
            //3
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            //4
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            //5
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled notification \(request) for itemID \(itemID)")
        }
    }
    //removeNotification
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    //will be invoked when you delete an individual ChecklistItem but also when you delete a whole Checklist – because all its ChecklistItems will be destroyed as well
    deinit {
        removeNotification()
    }
}
