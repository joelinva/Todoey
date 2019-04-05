//
//  item.swift
//  Todoey
//
//  Created by Joel Combs on 3/29/19.
//  Copyright © 2019 Joel Combs. All rights reserved.
//

import Foundation


class Item: Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
    
}
