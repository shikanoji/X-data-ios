//
//  APIService.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 08/07/2021.
//

import Foundation
import Moya
import Alamofire

enum APIError: Error {
    case someError
    case tokenError
    case permissionError
}

enum APIService {
    case getSiteHtml(url: String)
    case getGoogleSheet(ranges: String)
    case insertGoogleSheet(value: [[String]])
    case refreshAccessToken
}

extension APIService: TargetType {
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
        case .getSiteHtml(let url):
            return URL(string: url)!
        case .getGoogleSheet:
            return URL(string: Constant.api.googleSheetUrl)!
        case .insertGoogleSheet:
            return URL(string: Constant.api.googleSheetInsertUrl)!
        case .refreshAccessToken:
            return URL(string: Constant.api.googleRefreshAccessTokenUrl)!
        default:
            return URL(string: "")!
        }
        
    }

    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        default:
            return ""
        }
    }

    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getSiteHtml, .getGoogleSheet:
            return .get
        case .insertGoogleSheet, .refreshAccessToken:
            return .post
        }
    }

    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    // In this example we will not pass anything in the body of the request.
    var task: Task {
        switch self {
        case .getGoogleSheet(let ranges):
            var parameters: [String: Any] = [:]
            parameters["key"] = Constant.api.googleAPIKey
            parameters["major_dimension"] = "ROWS"
            parameters["ranges"] = ranges
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .insertGoogleSheet(let value):
            var parameters: [String: Any] = [:]
            var body: [String: Any] = [:]
            body["major_dimension"] = "ROWS"
            body["values"] = value
            parameters["insertDataOption"] = "INSERT_ROWS"
            parameters["valueInputOption"] = "RAW"
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: parameters)
        case .refreshAccessToken:
            var body: [String: Any] = [:]
            body["client_id"] = Constant.google.clientID
            body["refresh_token"] = AppSetting.shared.googleRefreshToken
            body["grant_type"] = "refresh_token"
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        default:
            return .requestPlain
        }
    }

    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        switch self {
        case .getSiteHtml:
            return ["Content-type": "text/html"]
        case .insertGoogleSheet:
            return ["Content-type": "application/json",
                    "Authorization" : "Bearer \(AppSetting.shared.googleAccessToken)"]
        default:
            return ["Content-type": "application/json"]
        }
    }

    // This is sample return data that you can use to mock and test your services,
    // but we won't be covering this.
    var sampleData: Data {
        return Data()
    }

}
