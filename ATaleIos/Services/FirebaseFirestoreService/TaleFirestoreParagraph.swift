//
//  TaleFirestoreParagraph.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/1/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation

struct TaleFirestoreParagraph: FirebaseModelProtocol {
    var creatorId: String
    var creatorUsername: String
    var creatorImageURL: URL?
    var paragraphText: String

    func toDictionary() -> [String : Any] {
        return [
            "creatorId" : creatorId,
            "creatorUsername" : creatorUsername,
            "creatorImageURL" : creatorImageURL?.absoluteString ?? "",
            "paragraphText" : paragraphText
        ]
    }
}

extension TaleFirestoreParagraph {
    init(from dictionary: [String: Any]) {
        self.creatorId = dictionary["creatorId"] as? String ?? ""
        self.creatorUsername = dictionary["creatorUsername"] as? String ?? ""
        self.creatorImageURL = URL(string: dictionary["creatorImageURL"] as? String ?? "")
        self.paragraphText = dictionary["paragraphText"] as? String ?? ""
    }
}
