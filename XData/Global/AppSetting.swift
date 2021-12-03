//
//  AppSetting.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 29/03/2021.
//

import Foundation

enum AppKeys: String {
    case latestUpdate = "latestUpdate"
    case googleAccessToken = "googleAccessToken"
    case googleRefreshToken = "googleRefreshToken"
}

struct AppSetting {
    static var shared = AppSetting()
    
    var latestUpdate: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.latestUpdate.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.latestUpdate.rawValue)
        }
    }
    
    var googleAccessToken: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.googleAccessToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.googleAccessToken.rawValue)
        }
    }
    
    var googleRefreshToken: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.googleRefreshToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.googleRefreshToken.rawValue)
        }
    }

    init() {
    }
}
