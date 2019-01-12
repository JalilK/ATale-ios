//
//  PlayerFirestoreModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/10/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation
import UIKit

struct PlayerFirestoreModel: FirebaseModelProtocol {
    var id: String
    var username: String
    var imageURL: URL?

    func toDictionary() -> [String : Any] {
        return [
            "id" : id,
            "username" : username,
            "imageURL" : imageURL?.absoluteString ?? ""
        ]
    }
}

extension PlayerFirestoreModel {
    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.imageURL = URL(string: dictionary["imageURL"] as? String ?? "")
    }
}

