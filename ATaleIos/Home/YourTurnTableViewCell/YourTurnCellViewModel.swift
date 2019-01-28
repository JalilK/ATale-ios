//
//  YourTurnCellViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/25/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class YourTurnCellViewModel: HomeCellViewModelType {
    private let taleModelBehaviorRelay: BehaviorRelay<TaleFirestoreModel>!

    lazy var taleColorDriver: Driver<UIColor> = {
        taleModelBehaviorRelay
            .map { $0.taleColor.color }
            .asDriver(onErrorJustReturn: UIColor.white)
    }()

    lazy var taleTitleDriver: Driver<String> = {
        taleModelBehaviorRelay
            .map { $0.taleTitle }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var playerImageDriver: Driver<UIImage> = {
        taleModelBehaviorRelay
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

    init(with taleModel: TaleFirestoreModel) {
        taleModelBehaviorRelay = BehaviorRelay<TaleFirestoreModel>(value: taleModel)
    }
}
