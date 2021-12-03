//
//  APIManager.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 08/07/2021.
//

import RxSwift
import Moya
import SwiftyJSON

struct APIManager {

    // I'm using a singleton for the sake of demonstration and other lies I tell myself
    static let shared = APIManager()
    
    // This is the provider for the service we defined earlier
    private var provider: MoyaProvider<APIService>
    
    private init() {
        let plugin = NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))
        self.provider = MoyaProvider<APIService>(plugins: [plugin])
    }
    
    
    func getSiteHtml(withUrl url: String) -> Single<String> {
        return provider.rx
            .request(.getSiteHtml(url: url))
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                return try response.mapString()
            }
            .catchError { error in
                throw APIError.someError
            }
    }
    
    func getGoogleSheet(withRanges ranges: String) -> Single<JSON> {
        return provider.rx
            .request(.getGoogleSheet(ranges: ranges))
            .filterSuccessfulStatusCodes()
            .map { response in
                let data = try response.mapJSON()
                return JSON(data)
            }
            .catchError { error in
                throw APIError.someError
            }
    }
    
    func insertGoogleSheet(value: [[String]]) -> Single<JSON> {
        return provider.rx
            .request(.insertGoogleSheet(value: value))
            .filterSuccessfulStatusCodes()
            .map { response in
                let data = try response.mapJSON()
                return JSON(data)
            }
            .catchError { error in
                throw APIError.someError
            }
    }
    
    func refreshAccessToken() -> Single<JSON> {
        return provider.rx
            .request(.refreshAccessToken)
            .filterSuccessfulStatusCodes()
            .map { response in
                let data = try response.mapJSON()
                return JSON(data)
            }
            .catchError { error in
                throw APIError.someError
            }
    }
}
