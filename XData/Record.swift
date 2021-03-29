//
//  Record.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 17/12/2020.
//

import Foundation
import ObjectMapper

class Record: Mappable {
    var date: String?
    var special: String?
    var first: String?
    var second: [String]?
    var third: [String]?
    var fourth: [String]?
    var fifth: [String]?
    var sixth: [String]?
    var seventh: [String]?

    required init?(map: Map) {
    }

    // Mappable
    func mapping(map: Map) {
        date    <- map["date"]
        special <- map["special"]
        first   <- map["first"]
        second  <- map["second"]
        third   <- map["third"]
        fourth  <- map["fourth"]
        fifth   <- map["fifth"]
        sixth   <- map["sixth"]
        seventh <- map["seventh"]
    }
    
    func deRecord() -> DeRecord? {
        var deRecord = [String: Any]()
        deRecord["date"] = date
        if let value = special?.suffix(2) {
            deRecord["value"] = String(value)
        }
        return DeRecord.init(JSON: deRecord)
    }
    
    func loRecord() -> LoRecord? {
        var loRecord = [String: Any]()
        loRecord["date"] = date
        var values = [String]()
        if let value1 = special?.suffix(2) {
            values.append(String(value1))
        }
        if let value2 = first?.suffix(2) {
            values.append(String(value2))
        }
        if let stack = second {
            for value in stack {
                values.append(String(value.suffix(2)))
            }
        }
        if let stack = third {
            for value in stack {
                values.append(String(value.suffix(2)))
            }
        }
        if let stack = fourth {
            for value in stack {
                values.append(String(value.suffix(2)))
            }
        }
        if let stack = fifth {
            for value in stack {
                values.append(String(value.suffix(2)))
            }
        }
        if let stack = sixth {
            for value in stack {
                values.append(String(value.suffix(2)))
            }
        }
        if let stack = seventh {
            for value in stack {
                values.append(String(value.suffix(2)))
            }
        }
        values.sort()
        loRecord["values"] = values
        return LoRecord.init(JSON: loRecord)
    }
}

class DeRecord: Mappable {
    var date: String?
    var value: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        value <- map["value"]
    }
}

class LoRecord: Mappable {
    var date: String?
    var value: [String]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        value <- map["values"]
    }
}
