//
//  Constant.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 06/07/2021.
//

import Foundation

struct Constant {
    struct Date {
        static let standardFormat = "yyyy-MM-dd"
    }
    
    struct api {
        static let googleAPIKey = "AIzaSyCR-XRFjnOEOupwBTJxfuWe1CQu8C8IcZ8"
        static let googleSheetUrl = "https://sheets.googleapis.com/v4/spreadsheets/1jrunFDuHSqf3yWx13JnCKMPlIRde8m3ENDhNaNbRx0E/values:batchGet"
        static let googleSheetInsertUrl = "https://sheets.googleapis.com/v4/spreadsheets/1jrunFDuHSqf3yWx13JnCKMPlIRde8m3ENDhNaNbRx0E/values/A1:B1:append"
        static let googleRefreshAccessTokenUrl = "https://www.googleapis.com/oauth2/v4/token"
    }
    
    struct google {
        static let clientID = "249432930688-89q7b6eijp74qiqrmdnfp2k9bunch1bl.apps.googleusercontent.com"
    }
}

