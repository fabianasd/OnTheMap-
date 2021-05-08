//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 25/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

 var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

    //verificar se a URL esta correta
       func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
           
           if components?.scheme == "onthemap" && components?.path == "authenticate" {
               let loginVC = window?.rootViewController as! LoginViewController
            OTMUser.createSessionId(username:"fafadiaz@hotmail.com", password: "Di4rioUdacity", completion: loginVC.handleLoginResponse(success:error:))
           }
           return true
       }
}

