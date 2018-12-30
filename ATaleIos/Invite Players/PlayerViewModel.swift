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
    private let playerModelBehaviorRelay: BehaviorRelay<PlayerModel>!
    let disposeBag = DisposeBag()

    lazy var playerSharedImageDriver: Driver<UIImage> = {
        playerModelBehaviorRelay
            .map { $0.profilePictureURL }
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
            .map { $0.name }
            .asDriver(onErrorJustReturn: "")
    }()

    init(playerModel: PlayerModel) {
        playerModelBehaviorRelay = BehaviorRelay<PlayerModel>(value: playerModel)
    }
}

extension PlayerViewModel: Equatable {
    static func == (lhs: PlayerViewModel, rhs: PlayerViewModel) -> Bool {
        return lhs.playerModelBehaviorRelay.value.id == rhs.playerModelBehaviorRelay.value.id
    }
}
