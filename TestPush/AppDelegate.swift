//
//  AppDelegate.swift
//  TestPush
//
//  Created by Andres Felipe Ocampo Eljaiek on 23/12/2020.
//  Copyright © 2020 everis.sl. All rights reserved.
//

import UIKit
import UserNotifications
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.settingParse()
        self.registerForPushNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Devce Token: \(token)")
        createInstallationOnParse(deviceTokenData: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Noti Silenciosa
    }
    
    
    // MARK: - Private methods
    func settingParse() {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "hZk4Zx14HSaLkfyj75Ea037TFruzkqqrSnU6Zwx1"
            $0.clientKey = "fNuW9W6bm82vYXUZMYk0OmPtbEGOi6uov2zgd0qD"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        self.saveInstallationObject()
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                print("denied")
            case .notDetermined:
                print("notDetermined")
            case .provisional:
                print("notDetermined")
            case .ephemeral:
                print("ephemeral")
            @unknown default:
                print("ko")
            }
        }
    }
    
    func createInstallationOnParse(deviceTokenData:Data){
        if let installation = PFInstallation.current(){
            installation.setDeviceTokenFrom(deviceTokenData)
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully saved your push installation to Back4App!")
                } else {
                    if let myError = error{
                        print("Error saving parse installation \(myError.localizedDescription)")
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }
    
    func saveInstallationObject(){
        if let installation = PFInstallation.current(){
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully connected your app to Back4App!")
                } else {
                    if let myError = error{
                        print(myError.localizedDescription)
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    

}



