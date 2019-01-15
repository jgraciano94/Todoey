//
//  Item.swift
//  Todoey
//
//  Created by Joshua Graciano on 1/12/19.
//  Copyright © 2019 Joshua Graciano. All rights reserved.
//

import Foundation
import RealmSwift

// superclass is going to be a realm object
class Item: Object {
    
    // in order to create properties using Realm, we have to have to add the @objc modifier and also the dynamic keyword
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // we called our inverse relationship, parent category, and it is going to be set to an object of the class Linking Objects. Linking Objects are auto-updating containers that represent 0 or more objects that are linked to its owning model object through a property relationship. In simple terms, it is defining the inverse relationship of items
    // we have to initialize LinkingObjects with a type and a property name. The type is going to be whatever Object we have .type. If you wrote just 'Category', then this is just the class not actually the type. In order to make it the type, we have to add '.self'. The property that we need to specify is what is the name of that forward relationship which is the constant items in Category.swift. All we need to do here is specify a string called items that points to the forward relationship.
    // this is the inverse relationship, each item has a parent category that is of the type Category and it comes from the property called items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
