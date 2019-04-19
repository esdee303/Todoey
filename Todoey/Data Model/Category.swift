//
//  Category.swift
//  Todoey
//
//  Created by Steven Deferme on 19/04/2019.
//  Copyright © 2019 Steven Deferme. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    // forward relationship
    let items = List<Item>()
}
