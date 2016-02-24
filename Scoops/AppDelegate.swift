//
//  AppDelegate.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //genero las credenciales para conectarme a Azure
    let client = getMSClient()
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        //esto es para recibir notificaciones
//        let notificationSettings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil )
//        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
//        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        
        //pongo un registro  a mano para probar
//        let item = ["titulo":"Dios!!", "texto":"Pues esta el panorama como para descuidarse","autor":"Anonimo","estado":"editando","user":"yo"]
//        let table = client.tableWithName("Noticias")
//        table.insert(item) {
//            (insertedItem, error : NSError?) in
//            print("Tenemos noticias")
//            if error != nil {
//                print("Error" + error!.description);
//            } else {
//                print("Item inserted, id: \( insertedItem["id"])")
//            }
//        }
        return true
    }

    //MARK: - Metodos de notificaciones
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        
//        client.push.registerNativeWithDeviceToken(deviceToken, tags: nil) { (error: NSError?) -> Void in
//            
//            if error != nil {
//                
//                print("Error -> \(error)")
//            }
//        }
//        
//        
//    }
//    
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        
//    }
//    
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        let payload = userInfo as Dictionary
//        print(payload)
//        
//        
//    }
//    
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

