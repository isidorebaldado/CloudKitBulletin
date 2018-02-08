//
//  AppDelegate.swift
//  AgnosticBulletin
//
//  Created by Isidore Baldado on 2/7/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

func runOnMain(_ task: @escaping () -> Void){
    DispatchQueue.main.async {
        task()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
    var hasBeenLaunched = UserDefaults.standard.bool(forKey: "hasBeenLaunched"){
        didSet{
            UserDefaults.standard.set(hasBeenLaunched, forKey: "hasBeenLaunched")
        }
    }
    
    // MARK: - App Life Cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        attemptRegisterForNotifications(application)
        return true
    }
    
    // MARK: - Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Notifications now allowed")
        if !hasBeenLaunched {
            PostController.shared.dataProvider.subscribeToPosts {_ in}
            hasBeenLaunched = true
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error: (\(error.localizedDescription))")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PostController.shared.manualReload()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        PostController.shared.manualReload()
    }
    
    // MARK:- Helper Functions
    
    fileprivate func attemptRegisterForNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            }
            if granted{
                DispatchQueue.main.async {
                    print("Registering for notifications")
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // MARK:- Garbage
    
    fileprivate func scratchCode(){
        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions { (subs, error) in
            if let subs = subs{
                for sub in subs{
                    CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: sub.subscriptionID, completionHandler: {_,_ in })
                }
            }
        }
    }


}

