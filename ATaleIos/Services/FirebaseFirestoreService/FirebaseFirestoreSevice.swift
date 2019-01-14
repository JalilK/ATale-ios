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
    case items = "items"
}

public enum FireStoreDocument: String {
    case pending = "pending"
    case active = "active"
    case completed = "completed"
}

class FirebaseFirestoreSevice {
    private let fireStoreDatabase = Firestore.firestore()

    func getPendingTales() -> Observable<[TaleFirestoreModel]> {
        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .document(FireStoreDocument.pending.rawValue)
            .collection(FireStoreCollection.items.rawValue)
            .rx
            .getDocuments()
            .map { $0.documents.map { TaleFirestoreModel(from: $0.data()) }}
    }

    func create(_ tale: TaleFirestoreModel) -> Observable<Void> {
        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .document(FireStoreDocument.pending.rawValue)
            .collection(FireStoreCollection.items.rawValue)
            .rx
            .addDocument(data: tale.toDictionary())
            .map { print("Document added with ID: \($0.documentID)") }
    }

    func update(_ tale: TaleFirestoreModel) -> Observable<Void> {
        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .document(FireStoreDocument.pending.rawValue)
            .collection(FireStoreCollection.items.rawValue)
            .whereField("id", isEqualTo: tale.id)
            .rx
            .getFirstDocument()
            .flatMapLatest { [unowned self] in
                self.fireStoreDatabase
                    .collection(FireStoreCollection.tales.rawValue)
                    .document(FireStoreDocument.pending.rawValue)
                    .collection(FireStoreCollection.items.rawValue)
                    .document($0.documentID)
                    .rx
                    .updateData(tale.toDictionary())
                    .take(1)
        }
    }
}
