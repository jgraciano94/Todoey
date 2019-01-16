//
//  Category.swift
//  Todoey
//
//  Created by Joshua Graciano on 1/12/19.
//  Copyright © 2019 Joshua Graciano. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = "" // we are going to save a hex string into this property
    
    // here we are going to create the forward relationship i.e. inside each category there is this thing called items which is going to point to a list of Item objects It is going to set equal to a collection type called 'List'. This is something that comes from Realm, and it is basically a container type (just as arrays and dictionaries are container types). It is very similar to arrays
    // we are going to create a constant called items and it is going to hold a list of Item objects and we're going to initialize it as an empty list
    let items = List<Item>()
    
    
}
