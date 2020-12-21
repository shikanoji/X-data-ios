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
        if let date = data["date"], date is String {
            db.collection("score").document(date as! String).setData(data) { err in
                if let err = err {
                    completionHandler(err)
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func lastestDate(completionHandler: @escaping (_ err: Error?, _ date: String?) -> Void){
        db.collection("score").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completionHandler(err, nil)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                if var lastestDate = dateFormatter.date(from: "01-01-2006") {
                    for document in querySnapshot!.documents {
                        if let documentDate = dateFormatter.date(from: document.documentID) {
                            if Calendar.current.compare(documentDate, to: lastestDate, toGranularity: .day) == .orderedDescending {
                                lastestDate = documentDate
                            } else {
                                continue
                            }
                        }
                    }
                    let dateString = dateFormatter.string(from: lastestDate)
                    completionHandler(nil, dateString)
                }
            }
        }
    }
}
