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
            .map { $0.profilePicture }
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
