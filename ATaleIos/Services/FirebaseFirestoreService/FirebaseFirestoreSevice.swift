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
import FirebaseAuth

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
        guard
            let currentUser = Auth.auth().currentUser,
            let currentUserProvider = currentUser.providerData.first(where: { $0.providerID == "facebook.com" })
            else { return Observable.empty() }

        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .document(FireStoreDocument.pending.rawValue)
            .collection(FireStoreCollection.items.rawValue)
            .rx
            .getDocuments()
            .map {
                $0.documents
                    .map { TaleFirestoreModel(from: $0.data()) }
                    .filter { $0.creatorId != currentUser.uid
                        && !$0.acceptedUsers.contains(where: { $0.id == currentUserProvider.uid })
                        && !$0.declinedUsers.contains(where: { $0.id == currentUserProvider.uid })
                }
        }
        .take(1)
    }

    func getYourTurnTales() -> Observable<[TaleFirestoreModel]> {
        guard
            let currentUser = Auth.auth().currentUser,
            let currentUserProvider = currentUser.providerData.first(where: { $0.providerID == "facebook.com" })
            else { return Observable.empty() }

        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .document(FireStoreDocument.active.rawValue)
            .collection(FireStoreCollection.items.rawValue)
            .rx
            .getDocuments()
            .map {
                $0.documents
                    .map { TaleFirestoreModel(from: $0.data()) }
                    .filter { $0.currentUserTurnId == currentUserProvider.uid && $0.currentRound <= 3 }
            }
    }

    func getCompletedTales() -> Observable<[TaleFirestoreModel]> {
        guard
            let currentUser = Auth.auth().currentUser,
            let currentUserProvider = currentUser.providerData.first(where: { $0.providerID == "facebook.com" })
            else { return Observable.empty() }

        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .document(FireStoreDocument.active.rawValue)
            .collection(FireStoreCollection.items.rawValue)
            .rx
            .getDocuments()
            .map {
                $0.documents
                    .map { TaleFirestoreModel(from: $0.data()) }
                    .filter { $0.currentRound > 3 && $0.acceptedUsers.contains(where: { $0.id == currentUserProvider.uid }) }
        }
    }

    func create(_ tale: TaleFirestoreModel, in document: FireStoreDocument = .pending) -> Observable<Void> {
        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .document(document.rawValue)
            .collection(FireStoreCollection.items.rawValue)
            .rx
            .addDocument(data: tale.toDictionary())
            .map { print("Document added with ID: \($0.documentID)") }
    }

    func update(_ tale: TaleFirestoreModel, in document: FireStoreDocument = .pending) -> Observable<Void> {
        return fireStoreDatabase
            .collection(FireStoreCollection.tales.rawValue)
            .document(document.rawValue)
            .collection(FireStoreCollection.items.rawValue)
            .whereField("id", isEqualTo: tale.id)
            .rx
            .getFirstDocument()
            .flatMapLatest { [unowned self] in
                self.fireStoreDatabase
                    .collection(FireStoreCollection.tales.rawValue)
                    .document(document.rawValue)
                    .collection(FireStoreCollection.items.rawValue)
                    .document($0.documentID)
                    .rx
                    .updateData(tale.toDictionary())
                    .take(1)
        }
    }
}
