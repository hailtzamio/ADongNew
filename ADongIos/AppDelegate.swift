//
//  AppDelegate.swift
//  ADongPr
//
//  Created by Cuongvh on 5/19/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver  {
//    dd299d1f-50fd-497e-9007-4889d0160097
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        
//        let center = UNUserNotificationCenter.current()
//              // Request permission to display alerts and play sounds.
//              center.requestAuthorization(options: [.alert, .sound])
//              { (granted, error) in
//                  // Enable or disable features based on authorization.
//              }
        
        // Override point for customization after application launch.
        openSplash()
//     UINavigationBar.appearance().barTintColor = UIColor(red: 46.0/255.0, green: 14.0/255.0, blue: 74.0/255.0, alpha: 1.0)
//        UINavigationBar.appearance().tintColor = UIColor.black
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
   
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        GMSServices.provideAPIKey("AIzaSyBEWloW2DR2zmONpY7SK_rjYn1ZDbs9ZKw")
        GMSPlacesClient.provideAPIKey("AIzaSyBEWloW2DR2zmONpY7SK_rjYn1ZDbs9ZKw")
        
  
        //Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
//
//        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
//        
        // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
          appId: "dd299d1f-50fd-497e-9007-4889d0160097",
          handleNotificationAction: nil,
          settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // The promptForPushNotifications function code will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 6)
         OneSignal.promptForPushNotifications(userResponse: { accepted in
           print("User accepted notifications: \(accepted)")
         })
        
        
        
//        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
//
//        let hasPrompted = status.permissionStatus.hasPrompted
//        print("hasPrompted = \(hasPrompted)")
//        if hasPrompted == false {
//          OneSignal.addTrigger("prompt_ios", withValue: "true")
//        }
        
        
        

        // Add your AppDelegate as an obsserver
       OneSignal.add(self as OSPermissionObserver)
       
       OneSignal.add(self as OSSubscriptionObserver)
        
        
        
        return true
    }
    
    func openSplash() {
        let loginVC = SplashViewController(nibName: "SplashViewController", bundle: nil)
        let nav = UINavigationController.init(rootViewController: loginVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    
    
    
    // MARK: UISceneSession Lifecycle
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ADongPr")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
           debugPrint("handleEventsForBackgroundURLSession: \(identifier)")
//           SDDownloadManager.shared.backgroundCompletionHandler = completionHandler
       }
    
}

