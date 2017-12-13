//
//  AppDelegate.swift
//  RigaDevDays
//
//  Created by Dmitry Beloborodov on 29/01/2017.
//  Copyright © 2017 RigaDevDays. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FirebaseAuthUI
import HockeySDK
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private(set) var scene: AppScene!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
            Log.enabled = true
            Log.level = .debug
        #endif
        
        application.isStatusBarHidden = false
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GMSServices.provideAPIKey("AIzaSyDQxCAYGUc64D2GlSAZuTOqoKZ-WKi5I8Q")

//        GIDSignIn.sharedInstance().delegate = LoginManager.shared
        // We're using FirebaseUI and there's no silent login
//        LoginManager.shared.loginSilently()
        
        DataManager.sharedInstance.startObservingPublicData()
        DataManager.sharedInstance.startMonitoringUser()
        GameDataManager.shared.startObservingGameData()
        CodeActivationManager.shared.start()
        
        setupHockeyApp()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = UIColor.rddDefaultColor
        scene = AppScene(window: window!)
        scene.start()
        window?.makeKeyAndVisible()
        
        if UserDefaults.standard.bool(forKey: "hasRunBefore") == false {
            
            // Remove Keychain items of firebase (simply log out)
            do {
                try FUIAuth.defaultAuthUI()?.signOut()
            } catch {
                Log.info("No user to logout")
            }
            
            // Update the flag indicator
            UserDefaults.standard.set(true, forKey: "hasRunBefore")
            UserDefaults.standard.synchronize()
        }
        
        return true
    }
    
    private func setupHockeyApp() {
        #if DEBUG
            let hockey = BITHockeyManager.shared()
            hockey.configure(withIdentifier: "4fe66ad06b094e68a2c7e514b5730fb9")
            hockey.start()
            hockey.crashManager.crashManagerStatus = .autoSend
        #endif
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
               ||
               FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}



