//
//  categoryController.swift
//  taskapp
//
//  Created by デザイン情報学科 on 2018/12/14.
//  Copyright © 2018年 shono.iso. All rights reserved.
//

import UIKit
import RealmSwift

class categoryController: UIViewController {
    @IBOutlet weak var categoryTextField: UITextField!
    var mycategory: Category!   // 追加する
    let realm = try! Realm()    // 追加する
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        categoryTextField.text = mycategory.categoryName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !categoryTextField.text!.isEmpty{
        try! realm.write {
            self.mycategory.categoryName = self.categoryTextField.text!
            self.realm.add(self.mycategory, update: true)
        }
        }
        super.viewWillDisappear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
