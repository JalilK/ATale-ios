//
//  NewTaleFirstLineViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/30/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class NewTaleFirstLineViewModel {
    private let firebaseAuthBehaviorRelay = BehaviorRelay<Auth>(value: Auth.auth())
    private let firebaseFirestoreServiceBehaviorRelay = BehaviorRelay<FirebaseFirestoreSevice>(value: FirebaseFirestoreSevice())
    private let firstLineTextBehaviorRelay = BehaviorRelay<String>(value: "")
    private let taleTitleBehaviorRelay = BehaviorRelay<String>(value: "")
    private let selectedColorBehaviorRelay = BehaviorRelay<TaleColor>(value: .darkTeal)
    private let invitedPlayersBehaviorRelay = BehaviorRelay<[PlayerFirestoreModel]>(value: [])
    private lazy var createTaleSharedObservable: Observable<Void> = {
        newLineAccessoryViewModel.selectButtonTappedPublishRelay
            .map { _ -> TaleFirestoreModel? in
                guard let currentUser = self.firebaseAuthBehaviorRelay.value.currentUser else { return nil }

                return TaleFirestoreModel(
                    creatorId: currentUser.uid,
                    taleColor: self.selectedColorBehaviorRelay.value,
                    taleTitle: self.taleTitleBehaviorRelay.value,
                    creatorUsername: currentUser.displayName ?? "",
                    creatorImageURL: currentUser.photoURL,
                    acceptedUsers: [],
                    declinedUsers: [],
                    invitedUsers: self.invitedPlayersBehaviorRelay.value,
                    taleParagraphs: [
                        TaleFirestoreParagraph(creatorId: currentUser.uid, creatorUsername: currentUser.displayName ?? "", creatorImageURL: currentUser.photoURL, paragraphText: self.firstLineTextBehaviorRelay.value)
                    ])
                }
                .filterNil()
                .flatMapLatest { model in
                    self.firebaseFirestoreServiceBehaviorRelay
                        .flatMapLatest { $0.create(model) }
                        .debug()
                        .take(1)
                }
                .share()
    }()

    let disposeBag = DisposeBag()
    let newLineAccessoryViewModel = NewLineAccessoryViewModel()

    lazy var selectedColorDriver: Driver<UIColor> = {
        selectedColorBehaviorRelay
            .map { $0.color }
            .asDriver(onErrorJustReturn: UIColor.clear)
    }()

    lazy var taleTitleDriver: Driver<String> = {
        taleTitleBehaviorRelay.asDriver()
    }()

    lazy var taleCreatedDriver: Driver<Void> = {
        createTaleSharedObservable.asDriver(onErrorJustReturn: ())
    }()

    let firstLineTextFieldTextPublishRelay = PublishRelay<String>()
    let selectedColorPublishRelay = PublishRelay<TaleColor>()
    let taleTitlePublishRelay = PublishRelay<String>()
    let invitedPlayersPublishRelay = PublishRelay<[PlayerFirestoreModel]>()

    init() {
        setupObservers()
        setupBindings()
    }

    private func setupObservers() {
        createTaleSharedObservable.subscribe(onError: {
            print("There was an error creating your tale: \($0)")
        })
        .disposed(by: disposeBag)
    }

    private func setupBindings() {
        let firstLineTextFieldTextSharedObservable = firstLineTextFieldTextPublishRelay.asObservable().share()

        firstLineTextFieldTextSharedObservable
            .bind(to: firstLineTextBehaviorRelay)
            .disposed(by: disposeBag)

        firstLineTextFieldTextSharedObservable
            .bind(to: newLineAccessoryViewModel.lineTextPublishRelay)
            .disposed(by: disposeBag)

        taleTitlePublishRelay
            .bind(to: taleTitleBehaviorRelay)
            .disposed(by: disposeBag)

        selectedColorPublishRelay
            .bind(to: selectedColorBehaviorRelay)
            .disposed(by: disposeBag)

        invitedPlayersPublishRelay
            .bind(to: invitedPlayersBehaviorRelay)
            .disposed(by: disposeBag)
    }
}
