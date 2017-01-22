//
//  ItemDetailViewController.swift
//  CheckLists
//
//  Created by ginger on 2017/1/10.
//  Copyright © 2017年 ginger. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        //如果itemToEdit不为nil，说明走的是EditItem的segue，在view出现之前做好初始化工作，改title，往textfield里填东西，并且设置Done按钮为可点击状态
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        //以下区别点击Done按钮时的两种响应，如果itemToEdit不为空说明此时目的为编辑Item而非添加新的Item，因此两种响应调用的代理方法也不同
        if let item = itemToEdit {
            item.text = textField.text!
            
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!)
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    //UITableViewDelegate协议的方法：使textfield所在行处于不可被选中的状态
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    //打开itemdetail界面时，键盘自动弹出
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    //one of the UITextField delegate methods. It is invoked every time the user changes the text, whether by tapping on the keyboard or by cut/paste.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString

        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
}
