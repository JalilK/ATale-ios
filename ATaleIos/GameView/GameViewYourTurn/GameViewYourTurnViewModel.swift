//
//  GameViewYourTurnViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/25/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class GameViewYourTurnViewModel {
    private let firebaseFirestoreServiceBehaviorRelay = BehaviorRelay<FirebaseFirestoreSevice>(value: FirebaseFirestoreSevice())
    private let firebaseAuthBehaviorRelay = BehaviorRelay<Auth>(value: Auth.auth())
    private let taleModelBehaviorRelay: BehaviorRelay<TaleFirestoreModel>!
    private let lineTextBehaviorRelay = BehaviorRelay<String>(value: "")

    let disposeBag = DisposeBag()

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

    lazy var roundTextDriver: Driver<String> = {
        taleModelBehaviorRelay
            .map { "Round: \($0.currentRound) / 3"}
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var submitNewLineDriver: Driver<Void> = {
        newLineAccessoryViewModel.selectButtonTappedPublishRelay
            .withLatestFrom(firebaseAuthBehaviorRelay)
            .map {
                return $0.currentUser?.providerData.first(where: { $0.providerID == "facebook.com" })
            }
            .filterNil()
            .withLatestFrom(lineTextBehaviorRelay) {
                TaleFirestoreParagraph(creatorId: $0.uid, date: Date(), creatorUsername: $0.displayName ?? "", creatorImageURL: $0.photoURL, paragraphText: $1)
            }
            .withLatestFrom(taleModelBehaviorRelay) {
                let paragraph = $0
                var taleModelToUpdate = $1
                taleModelToUpdate.taleParagraphs.append($0)

                if let index = taleModelToUpdate.acceptedUsers.firstIndex(where: { $0.id == paragraph.creatorId }) {
                    if index >= taleModelToUpdate.acceptedUsers.count - 1, let firstUser = taleModelToUpdate.acceptedUsers.first {
                        taleModelToUpdate.currentUserTurnId = firstUser.id
                        taleModelToUpdate.currentRound = taleModelToUpdate.currentRound + 1
                    } else {
                        taleModelToUpdate.currentUserTurnId = taleModelToUpdate.acceptedUsers[index+1].id
                    }
                }

                return taleModelToUpdate
            }
            .withLatestFrom(firebaseFirestoreServiceBehaviorRelay) { $1.update($0, in: .active) }
            .flatMapLatest { $0 }
            .asDriver(onErrorJustReturn: ())
    }()

    lazy var paragraphsObservable: Observable<[ParagraphCellViewModel]> = {
        taleModelBehaviorRelay
            .map { $0.taleParagraphs.map { ParagraphCellViewModel(with: $0) }}
    }()

    let lineTextPublishRelay = PublishRelay<String>()

    let cellConfiguration = { (row: Int, viewModel: ParagraphCellViewModel, cell: ParagraphTableViewCell) in
        cell.bind(to: viewModel)
    }

    let newLineAccessoryViewModel = NewLineAccessoryViewModel()

    init(with tale: TaleFirestoreModel) {
        taleModelBehaviorRelay = BehaviorRelay<TaleFirestoreModel>(value: tale)

        setupBindings()
    }

    private func setupBindings() {
        lineTextPublishRelay
            .bind(to: lineTextBehaviorRelay)
            .disposed(by: disposeBag)

        lineTextPublishRelay
            .bind(to: newLineAccessoryViewModel.lineTextPublishRelay)
            .disposed(by: disposeBag)
    }
}
