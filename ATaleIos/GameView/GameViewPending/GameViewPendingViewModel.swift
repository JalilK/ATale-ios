//
//  GameViewPendingViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/9/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
import RxDataSources
import Action

struct GamePendingSectionModel {
    var header: String
    var items: [PlayerViewModel]
}

extension GamePendingSectionModel: SectionModelType {
    typealias Item = PlayerViewModel

    init(original: GamePendingSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

class GameViewPendingViewModel {
    private let firebaseFirestoreServiceBehaviorRelay = BehaviorRelay<FirebaseFirestoreSevice>(value: FirebaseFirestoreSevice())
    private let taleModelBehaviorRelay: BehaviorRelay<TaleFirestoreModel>!

    private lazy var acceptedUsersObservable: Observable<GamePendingSectionModel> = {
        taleModelBehaviorRelay
            .map { $0.acceptedUsers.map { PlayerViewModel(playerModel: $0)}}
            .map { GamePendingSectionModel(header: "Accepted", items: $0)}
    }()

    private lazy var declinedUsersObservable: Observable<GamePendingSectionModel> = {
        taleModelBehaviorRelay
            .map { $0.declinedUsers.map { PlayerViewModel(playerModel: $0)}}
            .map { GamePendingSectionModel(header: "Declined", items: $0)}
    }()

    private lazy var invitedUsersObservable: Observable<GamePendingSectionModel> = {
        taleModelBehaviorRelay
            .map { $0.invitedUsers.map { PlayerViewModel(playerModel: $0)}}
            .map { GamePendingSectionModel(header: "Invited", items: $0)}
    }()

    lazy var tableViewDatasourceObservable: Observable<[GamePendingSectionModel]> = {
        Observable.combineLatest(acceptedUsersObservable, declinedUsersObservable, invitedUsersObservable) { accepted, declined, invited in
            var arr: [GamePendingSectionModel] = []

            if accepted.items.count > 0 { arr.append(accepted) }
            if declined.items.count > 0 { arr.append(declined) }
            if invited.items.count > 0 { arr.append(invited) }

            return arr
        }
    }()

    lazy var selectedColorDriver: Driver<UIColor> = {
        taleModelBehaviorRelay
            .map { $0.taleColor.color }
            .asDriver(onErrorJustReturn: UIColor.white)
    }()

    lazy var taleTitleDriver: Driver<String> = {
        taleModelBehaviorRelay
            .map { $0.taleTitle }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var taleCreatorImageDriver: Driver<UIImage> = {
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

    lazy var taleInviteTextDriver: Driver<String> = {
        taleModelBehaviorRelay
            .map { "\($0.creatorUsername) invited you."}
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var acceptAlertSignal: Signal<Void> = {
        acceptButtonTappedPublishRelay.asSignal()
    }()

    lazy var declineAlertSignal: Signal<Void> = {
        declineButtonTappedPublishRelay.asSignal()
    }()

    lazy var completionSignal: Signal<Bool> = {
        acceptInviteAlertYesButtonAction
            .executionObservables
            .flatMapLatest { $0 }
            .map { _ in true }
            .asSignal(onErrorJustReturn: false)
    }()

    var acceptInviteAlertYesButtonAction: CocoaAction!

    let disposeBag = DisposeBag()
    let acceptButtonTappedPublishRelay = PublishRelay<Void>()
    let declineButtonTappedPublishRelay = PublishRelay<Void>()

    var dataSource: RxTableViewSectionedReloadDataSource<GamePendingSectionModel>!

    init(taleModel: TaleFirestoreModel) {
        taleModelBehaviorRelay = BehaviorRelay<TaleFirestoreModel>(value: taleModel)
        setupDatasource()
        setupActions()
    }

    private func setupDatasource() {
        dataSource = RxTableViewSectionedReloadDataSource<GamePendingSectionModel>(configureCell: { (dataSource, tableView, indexPath, viewModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePlayersTableViewCell") as? InvitePlayersTableViewCell else { return UITableViewCell() }

            cell.bind(viewModel: viewModel)
            return cell
        })
    }

    private func setupActions() {
        acceptInviteAlertYesButtonAction = CocoaAction(workFactory: { [unowned self] in
            self.taleModelBehaviorRelay
                .map { [unowned self] in self.updateModelForInviteAcceptance(tale: $0) }
                .filterNil()
                .withLatestFrom(self.firebaseFirestoreServiceBehaviorRelay) { tale, firestoreService -> Observable<Void> in
                    if tale.invitedUsers.count == 0 {
                        return firestoreService
                            .update(tale)
                            .concat(firestoreService.create(tale, in: .active))
                    } else {
                        return firestoreService
                            .update(tale)
                    }
                }
                .flatMapLatest { $0 }
        })
    }
}

extension GameViewPendingViewModel {
    private func updateModelForInviteAcceptance(tale: TaleFirestoreModel) -> TaleFirestoreModel? {
        guard
            let currentUser = Auth.auth().currentUser,
            let currentUserProvider = currentUser.providerData.first(where: { $0.providerID == "facebook.com" }),
            let currentUserPlayerModel = tale.invitedUsers.first(where: { $0.id == currentUserProvider.uid })
            else { return nil }

        let invitedUsers = tale.invitedUsers.filter { $0.id != currentUserProvider.uid }
        let declinedUsers = tale.declinedUsers.filter { $0.id != currentUserProvider.uid }
        var acceptedUsers = tale.acceptedUsers.filter { $0.id != currentUserProvider.uid }

        acceptedUsers.append(currentUserPlayerModel)

        return TaleFirestoreModel(
            id: tale.id,
            creatorId: tale.creatorId,
            taleColor: tale.taleColor,
            taleTitle: tale.taleTitle,
            creatorUsername: tale.creatorUsername,
            creatorImageURL: tale.creatorImageURL,
            acceptedUsers: acceptedUsers,
            declinedUsers: declinedUsers,
            invitedUsers: invitedUsers,
            taleParagraphs: tale.taleParagraphs
        )
    }
}
