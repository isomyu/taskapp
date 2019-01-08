//
//  Task.swift
//  taskapp
//
//  Created by デザイン情報学科 on 2018/12/07.
//  Copyright © 2018年 shono.iso. All rights reserved.
//
import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    /// 日時
    @objc dynamic var date = Date()
    
    @objc dynamic var category = 0
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
