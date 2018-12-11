//
//  Item.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/5/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import Foundation

class Item : Codable {
    // we have to mark our class as conforming to the protocols Encodable. This means that the Item type is now able to encode itself into a plist or into a JSON.
    // In order for a class to be encodable, all of its properties must have standard data types (things like strings, booleans, arrays, dictionaries, etc.)
    // we also have to mark our class as conforming to the protocol Decodable, i.e. this is a type that only contains standard data types and it can be decoded from another representation which in our case is a plist
    // In swift 4, you can just use the keyword codable for both Encodable and Decodable. This specifies that a particular class and all of their objects conform to both the Encodable and the Decodable protocols
    
    var title : String = ""// this is where we are going to save the titles of our To Do's
    var done : Bool = false // this is where we are going to save whether the item was checked off or not. All items by default start off by being not done, so we set it to false.
    
}
