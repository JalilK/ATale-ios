//
//  NewTaleViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/26/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import RxFirebase
import RxOptional

class NewTaleViewModel {
    private let currentFirebaseUserBehaviorRelay: BehaviorRelay<User?>
    private let firebaseAuth = Auth.auth()
    private let maxCharacters = 50

    let disposeBag = DisposeBag()

    private let titleTextBehaviorRelay = BehaviorRelay<String>(value: "")

    let selectColorViewModels = [
        SelectColorViewModel(color: UIColor.darkTeal),
        SelectColorViewModel(color: UIColor.mustard),
        SelectColorViewModel(color: UIColor.orange),
        SelectColorViewModel(color: UIColor.pink),
        SelectColorViewModel(color: UIColor.green),
        SelectColorViewModel(color: UIColor.violet),
        SelectColorViewModel(color: UIColor.purple),
        SelectColorViewModel(color: UIColor.navy)
    ]

    let continueButtonTappedPublishRelay = PublishRelay<Void>()
    let titleTextFieldTextPublishRelay = PublishRelay<String>()
    let playerImageViewsContainerStackViewTappedPublishRelay = PublishRelay<UITapGestureRecognizer>()

    lazy var currentUserImageDriver: Driver<UIImage> = {
        currentFirebaseUserBehaviorRelay
            .filterNil()
            .map { $0.photoURL }
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

    lazy var characterCountTextDriver: Driver<String> = {
        titleTextBehaviorRelay
            .map { "\($0.count)/\(self.maxCharacters)" }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var titleTextFieldTextDriver: Driver<String> = {
        titleTextBehaviorRelay.asDriver(onErrorJustReturn: "")
    }()

    lazy var invitePlayersDriver: Driver<UIViewController> = {
        playerImageViewsContainerStackViewTappedPublishRelay.map { _ in
            UIStoryboard(name: "InvitePlayersViewController", bundle: nil).instantiateInitialViewController() ?? UIViewController()
        }
        .asDriver(onErrorJustReturn: UIViewController())
    }()

    init() {
        currentFirebaseUserBehaviorRelay = BehaviorRelay<User?>(value: firebaseAuth.currentUser)
        setupBindings()
    }

    private func setupBindings() {
        titleTextFieldTextPublishRelay
            .map { [unowned self] in
                return $0.count > self.maxCharacters ? String($0[..<$0.index($0.startIndex, offsetBy: self.maxCharacters)]) : $0
            }
            .bind(to: titleTextBehaviorRelay)
            .disposed(by: disposeBag)
    }
}
