//
//  Crawler.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 17/12/2020.
//

import Foundation
import Alamofire
import SwiftSoup

class Crawler {
    static let shared = Crawler()
    func getRecordOf(date: String, completionHandler: @escaping (_ data: [String:Any]?) -> Void) {
        AF.request("http://ketqua.net/xo-so-truyen-thong.php?ngay=\(date)").responseString{ response in
            if let html = response.value {
                completionHandler(self.parseHTML(html: html, date: date))
            } else {
                completionHandler(nil)
            }
        }
    }

    func parseHTML(html: String, date: String) -> [String: Any]? {
        guard let doc: Document = try? SwiftSoup.parseBodyFragment(html) else {
            return nil
        }
        do {
            var json: [String: Any] = [:]
            if let special =  try doc.getElementById("rs_0_0")?.text() {
                json["special"] = special
            }
            
            if let first =  try doc.getElementById("rs_1_0")?.text() {
                json["first"] = first
            }
            
            var secondArr = [String]()
            for i in 0...1 {
                let id = "rs_2_\(i)"
                if let second =  try doc.getElementById(id)?.text() {
                    secondArr.append(second)
                }
            }
            json["second"] = secondArr
            
            var thirdArr = [String]()
            for i in 0...5 {
                let id = "rs_3_\(i)"
                if let third =  try doc.getElementById(id)?.text() {
                    thirdArr.append(third)
                }
            }
            json["third"] = thirdArr
            
            var fourthArr = [String]()
            for i in 0...3 {
                let id = "rs_4_\(i)"
                if let fourth =  try doc.getElementById(id)?.text() {
                    fourthArr.append(fourth)
                }
            }
            json["fourth"] = fourthArr
            
            var fifthArr = [String]()
            for i in 0...5 {
                let id = "rs_5_\(i)"
                if let fifth =  try doc.getElementById(id)?.text() {
                    fifthArr.append(fifth)
                }
            }
            json["fifth"] = fifthArr
            
            var sixthArr = [String]()
            for i in 0...2 {
                let id = "rs_6_\(i)"
                if let sixth =  try doc.getElementById(id)?.text() {
                    sixthArr.append(sixth)
                }
            }
            json["sixth"] = sixthArr
            
            var seventhArr = [String]()
            for i in 0...3 {
                let id = "rs_7_\(i)"
                if let seventh =  try doc.getElementById(id)?.text() {
                    seventhArr.append(seventh)
                }
            }
            json["seventh"] = seventhArr
            
            json["date"] = date
            return json
        } catch {
            print("Error")
            return nil
        }
    }
}
