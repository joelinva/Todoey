//
//  Category.swift
//  Todoey
//
//  Created by Joel Combs on 4/15/19.
//  Copyright © 2019 Joel Combs. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var cellColor : String = ""
    let items = List<Item>()
    
}
