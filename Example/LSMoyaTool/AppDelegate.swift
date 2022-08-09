//
//  AppDelegate.swift
//  LSMoyaTool
//
//  Created by 墨鱼 on 08/09/2022.
//  Copyright (c) 2022 墨鱼. All rights reserved.
//

import UIKit
import LSMoyaTool

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LSMoyaConfiguration.shared.startWith(self)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

struct BaseNetModel: Decodable {
    let code: Int?
    let msg: String?
    var isSucceed: Bool {
        return 200 == code
    }
}

extension AppDelegate: LSMoyaConfigurationProtocol {
    func host() -> String {
        return "https://news-at.zhihu.com"
    }
    
    func baseModelIsSucceed(_ data: Data) -> Bool {
        let baseModel = try? JSONDecoder.init().decode(BaseNetModel.self, from: data)
        return baseModel?.isSucceed ?? false
    }
    
    func baseModelStatusCode(_ data: Data) -> String {
        let baseModel = try? JSONDecoder.init().decode(BaseNetModel.self, from: data)
        return String(baseModel?.code ?? 0)
    }
    
    func baseModelMessage(_ data: Data) -> String {
        let baseModel = try? JSONDecoder.init().decode(BaseNetModel.self, from: data)
        return baseModel?.msg ?? ""
    }
    
    func networkResponseCode() -> Int {
        return 200
    }
    
    func openLogger() -> Bool {
        return true
    }
    
}

