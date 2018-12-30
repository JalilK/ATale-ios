//
//  FacebookAPIService.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/27/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import FacebookCore
import RxSwift
import RxCocoa

struct FriendListRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        init(rawResponse: Any?) {
            guard
                let response = rawResponse as? Dictionary<String, Any>,
                let friends = response["data"] as? [Dictionary<String, Any>]
                else { return }

            friends.forEach {
                guard
                    let userId = $0["id"] as? String,
                    let name = $0["name"] as? String,
                    let picture = $0["picture"] as? Dictionary<String, Any>,
                    let pictureNode = picture["data"] as? Dictionary<String, Any>,
                    let pictureUrl = pictureNode["url"] as? String
                    else { return }

                let playerModel = PlayerModel(id: userId, name: name, profilePictureURL: URL(string: pictureUrl))

                self.playerModels.append(playerModel)
            }
        }

        var playerModels: [PlayerModel] = []
    }

    init(userId: String) {
        self.graphPath = "me/friends"
    }

    var graphPath = ""
    var parameters: [String : Any]? = ["fields": "id, name, picture"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

class FacebookAPIService {
    func getFriendList(userId: String) -> Observable<[PlayerModel]> {
        let connection = GraphRequestConnection()

        return Observable.create { observer in
            connection.add(FriendListRequest(userId: userId)) { response, result in
                switch result {
                case .success(let response):
                    observer.onNext(response.playerModels)
                    observer.onCompleted()
                case .failed(let error):
                    observer.onError(error)
                }
            }

            connection.start()
            return Disposables.create()
        }
    }
}
