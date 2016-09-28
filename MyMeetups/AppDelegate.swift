//
//  AppDelegate.swift
//  MyMeetups
//
//  Created by Dan Esrey on 2016/28/09.
//  Copyright © 2016 Dan Esrey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let bundle = Bundle.main
        guard let plistURL = bundle.url(forResource: "MeetupConfig", withExtension: "plist"),
        let plistData = try? Data(contentsOf: plistURL),
        let plist = (try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil)) as? [String:Any] else {
            fatalError("could not load MeetupConfig.plist")
        }
        
        let apiKey = plist["APIKey"] as? String
        let baseURL = plist["BaseURL"] as? String
        print(apiKey)
        print(baseURL)
 
        return true
    }
}

