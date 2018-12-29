//
//  InvitePlayersViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/27/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import RxFirebase

class InvitePlayersViewModel {
    private let currentFirebaseUserBehaviorRelay: BehaviorRelay<User?>!
    private let playerViewModelsBehaviorRelay = BehaviorRelay<[PlayerViewModel]>(value: [])
    private let selectedPlayersBehaviorRelay = BehaviorRelay<[PlayerViewModel]>(value: [])
    private let firebaseAuth = Auth.auth()
    private let facebookAPIService = FacebookAPIService()
    private let maxSelectedPlayers = 5

    let disposeBag = DisposeBag()
    let cellConfiguration = { (row: Int, viewModel: PlayerViewModel, cell: InvitePlayersTableViewCell) in
        cell.bind(viewModel: viewModel)
    }


    lazy var playViewModelsObservable: Observable<[PlayerViewModel]> = {
        playerViewModelsBehaviorRelay.asObservable()
    }()

    lazy var selectedPlayerViewModelsDriver: Driver<[PlayerViewModel]> = {
        selectedPlayersBehaviorRelay.asDriver()
    }()

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

    let playerViewModelSelectedPublishRelay = PublishRelay<PlayerViewModel>()

    init() {
        currentFirebaseUserBehaviorRelay = BehaviorRelay<User?>(value: firebaseAuth.currentUser)

        setupBindings()
    }

    private func setupBindings() {
        currentFirebaseUserBehaviorRelay
            .filterNil()
            .flatMap { [unowned self] in self.facebookAPIService.getFriendList(userId: $0.uid) }
            .map { $0.map { PlayerViewModel(playerModel: $0) } }
            .bind(to: playerViewModelsBehaviorRelay)
            .disposed(by: disposeBag)

        playerViewModelSelectedPublishRelay
            .map { [unowned self] viewModel in
                var arr = self.selectedPlayersBehaviorRelay.value

                if self.selectedPlayersBehaviorRelay.value.contains(where: { $0 == viewModel }) {
                    arr = self.selectedPlayersBehaviorRelay.value.filter { $0 != viewModel }
                } else {
                    arr = [viewModel] + self.selectedPlayersBehaviorRelay.value
                }

                return Array(arr.prefix(self.maxSelectedPlayers))
            }
            .bind(to: selectedPlayersBehaviorRelay)
            .disposed(by: disposeBag)
    }
}
