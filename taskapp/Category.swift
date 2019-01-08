//
//  Category.swift
//  taskapp
//
//  Created by デザイン情報学科 on 2018/12/14.
//  Copyright © 2018年 shono.iso. All rights reserved.
//
import RealmSwift

class Category:Object{
    @objc dynamic var id = 0
    @objc dynamic var categoryName = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

