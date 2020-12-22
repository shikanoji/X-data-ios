//
//  FirebaseHelper.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 16/12/2020.
//

import Foundation
import FirebaseFirestore

class FirebaseHelper {
    static let shared = FirebaseHelper()
    let db = Firestore.firestore()
    
    func addRecord(data: [String : Any], completionHandler: @escaping (_ err: Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = data["date"], date is String {
            db.collection("score").document(date as! String).setData(data) { err in
                if let err = err {
                    completionHandler(err)
                } else {
                    self.lastestDate { err, lastestDate in
                        if let checkDate = dateFormatter.date(from: date as! String), let _lastestDate = lastestDate, let lastest = dateFormatter.date(from: _lastestDate) {
                            if Calendar.current.compare(checkDate, to: lastest, toGranularity: .day) == .orderedDescending {
                                self.db.collection("info").document("lastestUpdate").setData(["date" : date]) { err in
                                    //Do something
                                }
                            }
                        }
                    }
                    completionHandler(nil)
                }
            }
        }
    }

    
    func lastestDate(completionHandler: @escaping (_ err: Error?, _ date: String?) -> Void) {
        let infoRef = db.collection("info")
        let lastestUpdate = infoRef.document("lastestUpdate")
        lastestUpdate.getDocument { (document, err) in
            if let document = document, document.exists {
                if let data = document.data(), let date = data["date"]{
                    completionHandler(nil, date as! String)
                } else {
                    completionHandler(nil, nil)
                }
            } else {
                completionHandler(err, nil)
            }
        }
    }
}
