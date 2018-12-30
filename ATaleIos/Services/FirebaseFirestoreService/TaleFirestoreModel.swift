//
//  TaleFirestoreModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/1/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation

public enum TaleState: Int {
    case inactive = 0
    case active = 1
    case completed = 2
}

struct TaleFirestoreModel: FirebaseModelProtocol {
    var taleColor: TaleColor
    var taleTitle: String
    var creatorUsername: String
    var creatorImageURL: URL?
    var taleParagraphs: [TaleFirestoreParagraph]

    func toDictionary() -> [String : Any] {
        return [
            "taleColor" : taleColor.rawValue,
            "taleTitle" : taleTitle,
            "creatorUsername" : creatorUsername,
            "creatorImageURL" : creatorImageURL?.absoluteString ?? "",
            "taleParagraphs" : taleParagraphs.map { $0.toDictionary() }
        ]
    }
}
