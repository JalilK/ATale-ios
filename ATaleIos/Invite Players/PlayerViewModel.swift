//
//  PlayerViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/27/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PlayerViewModel {
    private let playerModelBehaviorRelay: BehaviorRelay<PlayerFirestoreModel>!
    let disposeBag = DisposeBag()

    var playerModel: PlayerFirestoreModel {
        return playerModelBehaviorRelay.value
    }

    lazy var playerSharedImageDriver: Driver<UIImage> = {
        playerModelBehaviorRelay
            .map { $0.imageURL }
            .filterNil()
            .map { URLRequest(url: $0) }
            .flatMap {
                URLSession.shared.rx
                    .data(request: $0)
                    .subscribeOn(MainScheduler.instance)
            }
            .map { UIImage(data: $0) ?? UIImage() }
            .asDriver(onErrorJustReturn: UIImage())
            .asSharedSequence()
    }()

    lazy var playerNameTextDriver: Driver<String> = {
        playerModelBehaviorRelay
            .map { $0.username }
            .asDriver(onErrorJustReturn: "")
    }()

    init(playerModel: PlayerFirestoreModel) {
        playerModelBehaviorRelay = BehaviorRelay<PlayerFirestoreModel>(value: playerModel)
    }
}

extension PlayerViewModel: Equatable {
    static func == (lhs: PlayerViewModel, rhs: PlayerViewModel) -> Bool {
        return lhs.playerModelBehaviorRelay.value.id == rhs.playerModelBehaviorRelay.value.id
    }
}
