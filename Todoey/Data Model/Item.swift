//
//  Item.swift
//  Todoey
//
//  Created by Joel Combs on 4/15/19.
//  Copyright © 2019 Joel Combs. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   
    @objc dynamic var done : Bool = false
    @objc dynamic var title : String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
