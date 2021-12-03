//
//  FirebaseHelper.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 16/12/2020.
//

import Foundation
import FirebaseFirestore
import SwiftDate

class FirebaseHelper {
    static let shared = FirebaseHelper()
    let db = Firestore.firestore()
    
    func addRecord(data: Record?, completionHandler: @escaping (_ err: Error?) -> Void) {
        if let data = data, let date = data.date, date is String {
            db.collection("score").document(date as! String).setData(data.toJSON()) { err in
                if let err = err {
                    completionHandler(err)
                } else {
                    self.lastestDate { err, lastestDate in
                        if let cDate = date.toDate(), let lDate = lastestDate?.toDate(), cDate > lDate {
                            self.db.collection("info").document("latestUpdate").setData(["date" : date]) { err in
                                //Do something
                            }
                        }
                    }
                    completionHandler(nil)
                }
            }
            // Update De record
            if let deRecord = data.deRecord()?.toJSON() {
                db.collection("de").document(date).setData(deRecord)
            }
            if let loRecord = data.loRecord()?.toJSON() {
                db.collection("lo").document(date).setData(loRecord)
            }
        }
    }

    
    func lastestDate(completionHandler: @escaping (_ err: Error?, _ date: String?) -> Void) {
        let infoRef = db.collection("info")
        let lastestUpdate = infoRef.document("latestUpdate")
        lastestUpdate.getDocument { (document, err) in
            if let document = document, document.exists {
                if let data = document.data(), let date = data["date"]{
                    completionHandler(nil, date as? String)
                } else {
                    completionHandler(nil, nil)
                }
            } else {
                completionHandler(err, nil)
            }
        }
    }
}
