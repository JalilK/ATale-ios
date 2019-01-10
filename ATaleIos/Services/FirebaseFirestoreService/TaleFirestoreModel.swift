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
    var creatorId: String
    var taleColor: TaleColor
    var taleTitle: String
    var creatorUsername: String
    var creatorImageURL: URL?
    var taleParagraphs: [TaleFirestoreParagraph]

    func toDictionary() -> [String : Any] {
        return [
            "creatorId" : creatorId,
            "taleColor" : taleColor.rawValue,
            "taleTitle" : taleTitle,
            "creatorUsername" : creatorUsername,
            "creatorImageURL" : creatorImageURL?.absoluteString ?? "",
            "taleParagraphs" : taleParagraphs.map { $0.toDictionary() }
        ]
    }
}

extension TaleFirestoreModel {
    init(from dictionary: [String: Any]) {
        self.creatorId = dictionary["creatorId"] as? String ?? ""
        self.taleColor = TaleColor(rawValue: dictionary["taleColor"] as? String ?? "")
        self.taleTitle = dictionary["taleTitle"] as? String ?? ""
        self.creatorUsername = dictionary["creatorUsername"] as? String ?? ""
        self.creatorImageURL = URL(string: dictionary["creatorImageURL"] as? String ?? "")
        self.taleParagraphs = (dictionary["taleParagraphs"] as? [[String: Any]] ?? []).map { TaleFirestoreParagraph(from: $0) }
    }
}