//
//  PendingCollectionCellViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class PendingCollectionCellViewModel {
    private let pendingModelBehaviorRelay: BehaviorRelay<PendingTaleModel>

    lazy var selectedColorDriver: Driver<UIColor> = {
        pendingModelBehaviorRelay
            .map { $0.selectedColor }
            .asDriver(onErrorJustReturn: UIColor.clear)
    }()

    lazy var titleDriver: Driver<String> = {
        pendingModelBehaviorRelay
            .map { $0.title }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var userImageDriver: Driver<UIImage> = {
        pendingModelBehaviorRelay
            .map { $0.userImage }
            .asDriver(onErrorJustReturn: UIImage())
    }()

    lazy var inviteTextDriver: Driver<String> = {
        pendingModelBehaviorRelay
            .map { "\($0.senderUsername) invited you"}
            .asDriver(onErrorJustReturn: "")
    }()

    init(pendingTaleModel: PendingTaleModel) {
        self.pendingModelBehaviorRelay = BehaviorRelay<PendingTaleModel>(value: pendingTaleModel)
    }
}
