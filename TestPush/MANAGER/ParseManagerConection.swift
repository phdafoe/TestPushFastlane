//
//  ParseManagerConection.swift
//  TestPush
//
//  Created by Andres Felipe Ocampo Eljaiek on 10/01/2021.
//  Copyright © 2021 everis.sl. All rights reserved.
//

import Foundation
import UserNotifications
import Parse

class ParseManagerConnection {
    
    static let shared = ParseManagerConnection()
    
    internal func settingParse() {
        let configuration = ParseClientConfiguration {
            $0.applicationId = Utils.Constants.applicationId
            $0.clientKey = Utils.Constants.clientKey
            $0.server = Utils.Constants.server
        }
        Parse.initialize(with: configuration)
        self.saveInstallationObject()
    }
    
    internal func saveInstallationObject(){
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
    
    internal func createInstallationOnParse(deviceTokenData:Data){
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
}


