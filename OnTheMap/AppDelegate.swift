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
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    //verificar se a URL esta correta
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if components?.scheme == "onthemap" && components?.path == "authenticate" {
            let loginVC = window?.rootViewController as! LoginViewController
            OTMUser.createSessionId(username:"", password: "", completion: loginVC.handleSessionResponse(sessionResponse:error:))
        }
        return true
    }
}

