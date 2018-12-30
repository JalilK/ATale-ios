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
    private let selectedPlayersBehaviorRelay = BehaviorRelay<[PlayerViewModel]>(value: [])
    private let selectedColorViewModelBehaviorRelay = BehaviorRelay<SelectColorViewModel>(value: SelectColorViewModel(color: .darkTeal))
    private let firebaseAuth = Auth.auth()
    private let maxCharacters = 50

    let disposeBag = DisposeBag()

    private let titleTextBehaviorRelay = BehaviorRelay<String>(value: "")

    let selectColorViewModels = [
        SelectColorViewModel(color: .darkTeal),
        SelectColorViewModel(color: .mustard),
        SelectColorViewModel(color: .orange),
        SelectColorViewModel(color: .pink),
        SelectColorViewModel(color: .green),
        SelectColorViewModel(color: .violet),
        SelectColorViewModel(color: .purple),
        SelectColorViewModel(color: .navy)
    ]

    let continueButtonTappedPublishRelay = PublishRelay<Void>()
    let titleTextFieldTextPublishRelay = PublishRelay<String>()
    let colorViewModelSelectedPublishRelay = PublishRelay<SelectColorViewModel>()
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

    lazy var selectedPlayersDriver: Driver<[PlayerViewModel]> = {
        selectedPlayersBehaviorRelay.asDriver()
    }()

    lazy var firstLineDriver: Driver<UIViewController> = {
        continueButtonTappedPublishRelay.map { [unowned self] _ in
            let viewModel = NewTaleFirstLineViewModel()
            let vc = UIStoryboard(name: "NewTaleFirstLineViewController", bundle: nil).instantiateInitialViewController() ?? UIViewController()
            vc.title = "New Tale"

            guard let newTaleFirstLineViewController = vc as? NewTaleFirstLineViewController else { return vc }

            self.selectedColorViewModelBehaviorRelay
                .flatMap { $0.taleColorObservable.take(1) }
                .bind(to: viewModel.selectedColorPublishRelay)
                .disposed(by: viewModel.disposeBag)

            self.titleTextBehaviorRelay
                .bind(to: viewModel.taleTitlePublishRelay)
                .disposed(by: viewModel.disposeBag)

            newTaleFirstLineViewController.viewModel = viewModel

            return newTaleFirstLineViewController
        }
        .asDriver(onErrorJustReturn: UIViewController())
    }()

    lazy var invitePlayersDriver: Driver<UIViewController> = {
        playerImageViewsContainerStackViewTappedPublishRelay.map { [unowned self] _ in
            let vc = UIStoryboard(name: "InvitePlayersViewController", bundle: nil).instantiateInitialViewController() ?? UIViewController()

            guard let invitePlayersViewController = vc as? InvitePlayersViewController else { return vc }

            let viewModel = InvitePlayersViewModel()

            self.selectedPlayersBehaviorRelay
                .bind(to: viewModel.selectedPlayerViewModelsPublishRelay)
                .disposed(by: viewModel.disposeBag)

            viewModel.selectedPlayerViewModelsDriver
                .drive(self.selectedPlayersBehaviorRelay)
                .disposed(by: viewModel.disposeBag)

            invitePlayersViewController.viewModel = viewModel
            return invitePlayersViewController
        }
        .asDriver(onErrorJustReturn: UIViewController())
    }()

    lazy var continueButtonEnabledDriver: Driver<Bool> = {
        Observable.combineLatest(titleTextBehaviorRelay.asObservable(), selectedPlayersBehaviorRelay.asObservable()) { titleText, selectedPlayers in
            return titleText.count > 0 && selectedPlayers.count > 0
        }
        .asDriver(onErrorJustReturn: false)
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

        colorViewModelSelectedPublishRelay
            .bind(to: selectedColorViewModelBehaviorRelay)
            .disposed(by: disposeBag)
    }
}
