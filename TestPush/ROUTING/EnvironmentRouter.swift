//
//  EnvironmentRouter.swift
//  TestPush
//
//  Created by Andres Felipe Ocampo Eljaiek on 10/01/2021.
//  Copyright © 2021 everis.sl. All rights reserved.
//

import Foundation

open class EnvironmentRouter {
    
    static let environment = EnvironmentRouter()
}

public enum Environment {
    case development
    case testing
    case staging
    case production
    
    public init() {
        let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let plistDict = NSDictionary(contentsOfFile: plistPath!)!
        if let environmentString = plistDict["Environment"] as String {
            switch environmentString {
            case "DEVELOPMENT":
                self = .development
            case "TESTING":
                self = .testing
            case "STAGING":
                self = .staging
            default:
                self = .production
            }
            return
        }
        self = .production
    }
    
    public var name: String? {
        let infoDict = Bundle.main.infoDictionary
        let version = infoDict?["CFBundleShortVersionString"]
        let build = infoDict?[String(kCFBundleVersionKey)]
        let versionName = NSLocalizedString("version_title", value: "Version", comment: "version title")
        switch self {
        case .development:
            return "Development \(versionName): \(version ?? "") (\(build ?? ""))"
        case .testing:
            return "Testing \(versionName): \(version ?? "") (\(build ?? ""))"
        case .staging:
            return "Staging \(versionName): \(version ?? "") (\(build ?? ""))"
        default:
            return "\(versionName): \(version ?? "") (\(build ?? ""))"
        }
    }
    
    public func baseServiceURL() -> String {
        switch self {
        case .production:
            return "https://production.com"
        case .staging:
            return "https://staging.com"
        case .testing:
            return "https://testing.com"
        default:
            return "https://dev.com"
        }
    }
    
    public func isEnviroment(type: Environment) -> Bool {
        if type == self {
            return true
        }
        return false
    }
    
    public var isLive: Bool {
        switch self {
        case .production, .staging:
            return true
        default:
            return false
        }
    }
}


