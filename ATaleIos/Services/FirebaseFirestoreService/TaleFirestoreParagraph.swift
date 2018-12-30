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
