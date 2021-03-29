//
//  AppSetting.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 29/03/2021.
//

import Foundation

enum AppKeys: String {
    case latestUpdate = "latestUpdate"
}

struct AppSetting {
    static let shared = AppSetting()
    
    var latestUpdate: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.latestUpdate.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.latestUpdate.rawValue)
        }
    }

    init() {
    }
}
