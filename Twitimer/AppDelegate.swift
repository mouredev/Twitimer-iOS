//
//  AppDelegate.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseMessaging
import IQKeyboardManagerSwift
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Setup
        setupSDK(application)
        setupUI(application)
        
        return true
    }
    
    // MARK: Setup
    
    private func setupSDK(_ application: UIApplication) {
        
        // Firebase
        FirebaseApp.configure()
        
        // Remote notifications
        UNUserNotificationCenter.current().delegate = self
        //Util.requestPushAuthorization(application: application)
        Messaging.messaging().delegate = self
    }
    
    private func setupUI(_ application: UIApplication) {
        
        // Badge
        application.applicationIconBadgeNumber = 0
        
        // UINavigationBar
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = Color.primaryColor.uiColor
        UINavigationBar.appearance().tintColor = Color.lightColor.uiColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: Color.lightColor.uiColor,
            .font: UIFont(descriptor: UIFontDescriptor(name: FontType.bold.rawValue, size: FontSize.head.rawValue), size: FontSize.head.rawValue)
        ]
        
        let backIndicatorImage = UIImage(named: "keyboard-arrow-left")
        UINavigationBar.appearance().backIndicatorImage = backIndicatorImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIndicatorImage
        
        // UITabBar (TabView)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = Color.backgroundColor.uiColor
        UITabBar.appearance().tintColor = Color.primaryColor.uiColor
        UITabBar.appearance().clipsToBounds = true // Remove top line
        
        // UITableView (List)
        UITableView.appearance().backgroundColor = Color.secondaryBackgroundColor.uiColor
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
        UITableViewCell.appearance().backgroundColor = Color.secondaryBackgroundColor.uiColor
        UITableViewCell.appearance().selectionStyle = .none
        
        // UIAlertController (Alert)
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = Color.primaryColor.uiColor
        
        // UITextField (TextField)
        UITextField.appearance().overrideUserInterfaceStyle = .light
        
        // UIPageControl
        UIPageControl.appearance().currentPageIndicatorTintColor = Color.primaryColor.uiColor
        UIPageControl.appearance().pageIndicatorTintColor = Color.primaryColor.uiColor.withAlphaComponent(CGFloat(UIConstants.kShadowOpacity))
        
        // IQKeyboardManagerSwift
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }
    
}

// MARK: UNUserNotificationCenterDelegate, MessagingDelegate

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        debugPrint("FCM token: \(fcmToken ?? "No FCM token")")
        
        Session.shared.setupNotification()
    }
    
}
