//
//  InputViewController.swift
//  taskapp
//
//  Created by デザイン情報学科 on 2018/12/07.
//  Copyright © 2018年 shono.iso. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate{
    @IBOutlet weak var ContentsTextView: UITextView!
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var CategoryPicker: UIPickerView!
    @IBOutlet weak var categoryMakeButton: UIButton!
    var task: Task!   // 追加する
    let realm = try! Realm()    // 追加する
    var categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "id", ascending: true)  // ←追加
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CategoryPicker.delegate=self
        CategoryPicker.dataSource=self
        navigationController?.delegate = self
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        TitleTextField.text = task.title
        ContentsTextView.text = task.contents
        DatePicker.date = task.date
        CategoryPicker.selectRow(task.category,inComponent: 0,animated: true)
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
 */
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ViewController {
            try! realm.write {
                self.task.title = self.TitleTextField.text!
                self.task.contents = self.ContentsTextView.text
                self.task.date = self.DatePicker.date
                if(self.CategoryPicker.dataSource != nil){
                    self.task.category = CategoryPicker.selectedRow(inComponent: 0)
                }
                self.realm.add(self.task, update: true)
            }
            setNotification(task: task)   // 追加
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let categorycontroller:categoryController = segue.destination as! categoryController
        let mycategory = Category()
        if segue.identifier == "categorySegue" {
            let allCategory = realm.objects(Category.self)
            if allCategory.count != 0 {
                mycategory.id = allCategory.max(ofProperty: "id")! + 1
            }
            categorycontroller.mycategory = mycategory
        }
    }
    
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    
    func numberOfComponents(in categoryPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ categoryPicker: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ categoryPicker: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return categoryArray[row].categoryName
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CategoryPicker.reloadAllComponents()
    }
}
