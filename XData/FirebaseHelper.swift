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
                var year = 2006
                var month = 1
                var date = 1
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    guard let iYear = Int(String(id.suffix(4))) else {
                        continue
                    }
                    
                    if iYear < year {
                        continue
                    }
                    
                    guard let iDate = Int(String(id.prefix(2))) else {
                        continue
                    }
                    let start = id.index(id.startIndex, offsetBy: 3)
                    let end = id.index(id.endIndex, offsetBy: -5)
                    let range = start..<end

                    let mySubstring = id[range]
                    guard let iMonth = Int(String(mySubstring)) else {
                        continue
                    }
                    
                    if iYear > year {
                        year = iYear
                        month = iMonth
                        date = iDate
                    }
                }
            }
        }
    }
}
