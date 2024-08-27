//
//  AppDelegate.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/6.
//

import UIKit
import RealmSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 配置 Realm 的遷移
                let config = Realm.Configuration(
                    schemaVersion: 1, // 更新此版本號以進行遷移
                    migrationBlock: { migration, oldSchemaVersion in
                        // 如果需要手動遷移，可以在這裡處理
                        // 在這裡可以留空來使用自動遷移
                        if oldSchemaVersion < 1 {
                            // 自動遷移會處理大部分簡單的變更
                        }
                    }
                )
                    
                // 設置 Realm 的配置
                Realm.Configuration.defaultConfiguration = config
                return true
    }
    func clearRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
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

