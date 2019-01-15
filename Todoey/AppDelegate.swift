//
//  AppDelegate.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/4/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // this is a place that gets called when your app gets loaded up so it doesn't atter if the rest of your app is going to crash. This is the first thing that happens and this happens before the viewDidLoad inside the first View Controller or the initial view controller
        
        // we are going to create our new item (i.e. create in CRUD), and we're going to commit the current state of our realm. As with Core Data, we basically created a new piece of data, then we used the context to commit the current state to our persistent container or in this case it's our Realm Database.
        // we are going to create our brand new realm. Realms are kind of like different persistent containers. We set realm equal to a new Realm object from the Realm class. The initialization of a new realm is actually marked with a throw so we have to mark it with a try and a do catch block.
        // Realm allows us to use OOP and persist objects
        
//        print(Realm.Configuration.defaultConfiguration.fileURL) // in the future we may want to find out where our Realm file is, so keep this here
        
        do {
            _ = try Realm() // we are going to use this to save a new piece of data
            // because we are not really using this constant here we can make this constant name an underscore. You can also delete the let keyword as well.
        } catch {
            print ("Error initializing new realm, \(error)")
        }
       
        return true
    }
}

