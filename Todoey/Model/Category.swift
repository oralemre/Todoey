//
//  Category.swift
//  Todoey
//
//  Created by Emre Oral on 7/31/19.
//  Copyright © 2019 Emre Oral. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // forward relationship
//    let  array : Array<Int> = [1,2,3] valid syntax
//    let array = Array<Int>() empty array of integers
    
}

