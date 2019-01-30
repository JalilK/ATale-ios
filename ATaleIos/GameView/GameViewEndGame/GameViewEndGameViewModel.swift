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
    private let playerColorViewModelsBehaviorRelay = BehaviorRelay<[SelectColorViewModel]>(value: [
        SelectColorViewModel(color: .darkTeal),
        SelectColorViewModel(color: .mustard),
        SelectColorViewModel(color: .orange),
        SelectColorViewModel(color: .pink),
        SelectColorViewModel(color: .green),
        SelectColorViewModel(color: .violet)
    ])

    private lazy var playerColorsObservable: Observable<[UIColor]> = {
        playerColorViewModelsBehaviorRelay
            .map { $0.map { $0.taleColorObservable }}
            .flatMapLatest { Observable.zip($0) }
            .map { $0.map { $0.color }}
    }()

    private lazy var playerForColorDictionaryObservable: Observable<[String: UIColor]> = {
        taleModelBehaviorRelay
            .map { $0.acceptedUsers }
            .withLatestFrom(playerColorsObservable) { acceptedUsers, colors in
                var dict: [String: UIColor] = [:]

                acceptedUsers.enumerated().forEach {
                    dict[$0.1.id] = colors[$0.0]
                }

                return dict
            }
    }()

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

    lazy var playerColorsDriver: Driver<[UIColor]> = {
        taleModelBehaviorRelay
            .map { $0.acceptedUsers }
            .withLatestFrom(playerColorsObservable) { Array($1.prefix($0.count)) }
            .asDriver(onErrorJustReturn: [])
    }()

    lazy var taleParagraphsDriver: Driver<[(TaleFirestoreParagraph, UIColor)]> = {
        taleModelBehaviorRelay
            .map { $0.taleParagraphs }
            .withLatestFrom(playerForColorDictionaryObservable) { paragraphs, dictionary in
                paragraphs.map { ($0, dictionary[$0.creatorId] ?? UIColor.black) }
            }
            .asDriver(onErrorJustReturn: [])
    }()

    init(with tale: TaleFirestoreModel) {
        taleModelBehaviorRelay = BehaviorRelay<TaleFirestoreModel>(value: tale)
    }
}
