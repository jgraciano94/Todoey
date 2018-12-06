//
//  AppDelegate.swift
//  Todoey
//
//  Created by Joshua Graciano on 12/4/18.
//  Copyright © 2018 Joshua Graciano. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // this is a place that gets called when your app gets loaded up so it doesn't atter if the rest of your app is going to crash. This is the first thing that happens and this happens before the viewDidLoad inside the first View Controller or the initial view controller
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)// here we are writing code to printout the path for our User Defaults file. We are accessing the last element of the array and printing it out as a string
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // this tends to get triggered when say something happens to the phone while the app is open i.e. in the foreground. So say if the user receives a call, this is the method where you can do something to prevent the use of losing data. So for example, say if the user were filling in a form in your app and in the middle of it they get a call. It would be really annoying if at the end of the call, the app terminated and lost all of their data
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // This happens when your app disappears off the screen. When you press the home button for exeample or when you open up a different app. Your app is no longer visible and it has entered the background
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // This is the point where basically your app is going to be terminated. This can be user triggered or system triggered. Let's say we close out of one app and enter another and let's also say this other app is very resource intensive (such as a game), then it might reclaim some of the resources of the app in the background. When this happens, it goes from being in the background to being terminated by the OS
    }


}

