//
//  FirebaseFirestoreSevice.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/1/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFirebase
import FirebaseFirestore

public enum FireStoreCollection: String {
    case tales = "tales"
}

class FirebaseFirestoreSevice {
    private let fireStoreDatabase = Firestore.firestore()

    func create(_ tale: TaleFirestoreModel) -> Observable<Void> {
        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .rx
            .addDocument(data: tale.toDictionary())
            .map { print("Document added with ID: \($0.documentID)") }
    }
}
