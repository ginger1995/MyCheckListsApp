//
//  ViewController.swift
//  CheckLists
//
//  Created by ginger on 2017/1/6.
//  Copyright © 2017年 ginger. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController ,ItemDetailViewControllerDelegate{
    
    //【!】is similar to optionals with a question mark, but you don’t have to write if let to unwrap it.
    var checklist: Checklist!
    
    //This initial method is for view controllers that are automatically loaded from a storyboard
//    required init?(coder aDecoder: NSCoder) {
//        //make sure all instance variable items has a proper value
//        items = [ChecklistItem]()
//        
//        super.init(coder: aDecoder)
//        
//        loadChecklistItems()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //覆盖UItableViewDatasource protocol中的方法：方法返回tableview的总行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    //覆盖UItableViewDatasource protocol中的方法：方法为索引指定的行返回一个cell，通过该方法为所有的行添加cell（数据）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //gets a copy of the prototype cell – either a new one or a recycled one – and puts it into the local constant
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        configureText(for:cell, with:item)
        configureCheckmark(for:cell, with:item)
        return cell
    }
    //覆盖UItableviewdelegate协议中的方法，gets called whenever the user taps on a cell.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for:cell, with:item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistItems()
    }
    
    //覆盖UItableViewDatasource protocol中的方法：Asks the data source to commit the insertion or deletion of a specified row in the receiver.(右划item删除项目)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //1.remove the item from the data model
        checklist.items.remove(at: indexPath.row)
        //2.delete the corresponding row from the table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveChecklistItems()
    }
    
    //prepare-for-segue allows you to give data to the new view controller before it will be displayed.(为页面跳转做准备)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            //此时navigationController的最顶层显示的就是ItemDetailViewController
            let controller = navigationController.topViewController as! ItemDetailViewController
            //设置本viewcontroller为ItemDetailViewController的代理
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                //给ItemDetailViewController类的itemToEdit变量传值
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    //ItemDetailViewControllerDelegate 点击AddItem界面的navigationController的Cancel按钮的行为
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    //ItemDetailViewControllerDelegate 点击AddItem界面的navigationController的Done按钮的行为(添加新的Item)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
    }
    //ItemDetailViewControllerDelegate 点击AddItem界面的navigationController的Done按钮的行为(修改现有的Item)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of:item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
    }
    //配置cell上的✅
    func configureCheckmark(for cell:UITableViewCell, with item:ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    //配置cell上的文字
    func configureText(for cell:UITableViewCell, with item:ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
}
