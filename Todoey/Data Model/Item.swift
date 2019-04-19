//
//  Item.swift
//  Todoey
//
//  Created by Steven Deferme on 19/04/2019.
//  Copyright © 2019 Steven Deferme. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    // reverse category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
