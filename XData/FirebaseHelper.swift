//
//  FirebaseHelper.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 16/12/2020.
//

import Foundation
import FirebaseFirestore

class FirebaseHelper {
    let db = Firestore.firestore()
    func addRecord(json: [String : Any]) {
        var ref: DocumentReference? = nil
        ref = db.collection("score").addDocument(data: json) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
