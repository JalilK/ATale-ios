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
    private let pendingModelBehaviorRelay: BehaviorRelay<TaleFirestoreModel>

    lazy var selectedColorDriver: Driver<UIColor> = {
        pendingModelBehaviorRelay
            .map { $0.taleColor.color }
            .asDriver(onErrorJustReturn: UIColor.clear)
    }()

    lazy var titleDriver: Driver<String> = {
        pendingModelBehaviorRelay
            .map { $0.taleTitle }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var userImageDriver: Driver<UIImage> = {
        pendingModelBehaviorRelay
            .map { $0.creatorImageURL }
            .filterNil()
            .map { URLRequest(url: $0) }
            .flatMap {
                URLSession.shared.rx
                    .data(request: $0)
                    .subscribeOn(MainScheduler.instance)
            }
            .map { UIImage(data: $0) ?? UIImage() }
            .asDriver(onErrorJustReturn: UIImage())
    }()

    lazy var inviteTextDriver: Driver<String> = {
        pendingModelBehaviorRelay
            .map { "\($0.creatorUsername) invited you"}
            .asDriver(onErrorJustReturn: "")
    }()

    init(pendingTaleModel: TaleFirestoreModel) {
        self.pendingModelBehaviorRelay = BehaviorRelay<TaleFirestoreModel>(value: pendingTaleModel)
    }
}
