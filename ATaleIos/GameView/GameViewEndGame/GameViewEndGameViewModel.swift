//
//  GameViewEndGameViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/30/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GameViewEndGameViewModel {
    private let taleModelBehaviorRelay: BehaviorRelay<TaleFirestoreModel>!

    lazy var taleColorDriver: Driver<UIColor> = {
        taleModelBehaviorRelay
            .asDriver()
            .map { $0.taleColor.color }
    }()

    lazy var taleTitleTextDriver: Driver<String> = {
        taleModelBehaviorRelay
            .asDriver()
            .map { $0.taleTitle }
    }()

    lazy var playerImagesDriver: Driver<[UIImage]> = {
        taleModelBehaviorRelay
            .map {
                $0.acceptedUsers
                    .compactMap { $0.imageURL }
                    .map { URLRequest(url: $0) }
            }
            .flatMapLatest {
                Observable.combineLatest(
                    $0.map {
                        URLSession.shared.rx
                            .data(request: $0)
                            .subscribeOn(MainScheduler.instance)
                    }
                )
            }
            .map { $0.map { UIImage(data: $0) ?? UIImage() }}
            .asDriver(onErrorJustReturn: [])
    }()

    lazy var taleParagraphsDriver: Driver<[TaleFirestoreParagraph]> = {
        taleModelBehaviorRelay
            .asDriver()
            .map { $0.taleParagraphs }
    }()

    init(with tale: TaleFirestoreModel) {
        taleModelBehaviorRelay = BehaviorRelay<TaleFirestoreModel>(value: tale)
    }
}
