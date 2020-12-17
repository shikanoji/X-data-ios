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
    func getRecordOf(date: String) {
        AF.request("http://ketqua.net/xo-so-truyen-thong.php?ngay=\(date)").responseString { response in
            if let html = response.value {
                self.parseHTML(html: html)
            }
        }
    }

    func parseHTML(html: String) -> Void {
        guard let doc: Document = try? SwiftSoup.parseBodyFragment(html) else {
            return
        }
        do {
            if let special =  try doc.getElementById("rs_0_0")?.firstElementSibling()?.text() {
                print(special)
            }
        } catch {
            print("Error")
        }
    }
}
