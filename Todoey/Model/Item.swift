//
//  Item.swift
//  Todoey
//
//  Created by Emre Oral on 7/31/19.
//  Copyright © 2019 Emre Oral. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    //@objc dynamic var itemColor : String = ""
    // inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // Category class .self type
    
    
}
