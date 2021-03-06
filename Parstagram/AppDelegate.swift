//
//  AppDelegate.swift
//  Parstagram
//
//  Created by Natalie Meneses on 10/21/20.
//  Copyright © 2020 NatalieM. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        let parseConfig = ParseClientConfiguration {
                $0.applicationId = "SdF6f6WJc1pkIDQPZCP9wskPaQ2Ow8As12DUk7LW"
                $0.clientKey = "0DotakvI1fiGXg2UYunk8EWudWqMqvUUOl2Y2eYQ"
                $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
      
        return true
    }
  
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

