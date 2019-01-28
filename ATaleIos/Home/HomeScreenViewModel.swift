//
//  HomeScreenViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct HomeSectionModel {
    var header: String
    var items: [HomeCellViewModelType]
}

extension HomeSectionModel: SectionModelType {
    typealias Item = HomeCellViewModelType

    init(original: HomeSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

class HomeScreenViewModel {
    private let firestStoreServiceBehaviorRelay = BehaviorRelay<FirebaseFirestoreSevice>(value: FirebaseFirestoreSevice())
    private let pendingViewModelSelectedPublishRelay = PublishRelay<PendingCollectionCellViewModel>()

    private lazy var pendingTalesObservable: Observable<HomeSectionModel> = {
        viewDidAppearPublishRelay
            .withLatestFrom(firestStoreServiceBehaviorRelay)
            .flatMapLatest { $0.getPendingTales() }
            .map {
                let homePendingViewModel = HomePendingViewModel(pendingTales: $0)
                homePendingViewModel.viewModelSelectedPublishRelay
                    .bind(to: self.pendingViewModelSelectedPublishRelay)
                    .disposed(by: homePendingViewModel.disposeBag)

                return $0.count > 0 ? HomeSectionModel(header: "Pending", items: [homePendingViewModel]) : HomeSectionModel(header: "", items: [])
            }
    }()

    private lazy var yourTurnTalesObservable: Observable<HomeSectionModel> = {
        viewDidAppearPublishRelay
            .withLatestFrom(firestStoreServiceBehaviorRelay)
            .flatMapLatest { $0.getYourTurnTales() }
            .map { $0.map { YourTurnCellViewModel(with: $0) }}
            .map { HomeSectionModel(header: "Your Turn", items: $0) }
    }()

    lazy var homeCellViewModelsObservable: Observable<[HomeSectionModel]> = {
        Observable.combineLatest(pendingTalesObservable, yourTurnTalesObservable) { pendingTales, yourTurnTales in
            var arr: [HomeSectionModel] = []

            if pendingTales.items.count > 0 { arr.append(pendingTales) }
            if yourTurnTales.items.count > 0 { arr.append(yourTurnTales) }

            return arr
        }
    }()

    lazy var pendingGameViewDriver: Driver<UIViewController> = {
        pendingViewModelSelectedPublishRelay
            .flatMapLatest { $0.pendingModelObservable.take(1) }
            .map { viewModel -> UIViewController? in
                guard let vc = UIStoryboard(name: "GameViewPendingViewController", bundle: nil).instantiateInitialViewController() as? GameViewPendingViewController else { return nil }

                vc.viewModel = GameViewPendingViewModel(taleModel: viewModel)
                return vc
            }
            .filterNil()
            .asDriver(onErrorJustReturn: UIViewController())
    }()

    lazy var newTaleDriver: Driver<UIViewController> = {
        homeNavigationBarViewModel.newFableButtonPublishRelay.map {
            let vc = (UIStoryboard(name: "NewTaleViewController", bundle: nil).instantiateInitialViewController() ?? UIViewController())
            vc.title = "New Tale"

            return vc
        }
        .asDriver(onErrorJustReturn: UIViewController())
    }()

    lazy var yourTurnGameViewDriver: Driver<UIViewController> = {
        yourTurnModelSelectedPublishRelay
            .withLatestFrom(yourTurnModelSelectedPublishRelay.flatMapLatest { $0.taleModelObservable }) { ($0, $1) }
            .map { tuple -> UIViewController in
                guard let vc = UIStoryboard(name: "GameViewYourTurnViewController", bundle: nil).instantiateInitialViewController() as? GameViewYourTurnViewController else { return UIViewController() }

                let viewModel = GameViewYourTurnViewModel(with: tuple.1)
                vc.viewModel = viewModel

                return vc
            }
            .asDriver(onErrorJustReturn: UIViewController())
    }()

    let viewDidAppearPublishRelay = PublishRelay<Void>()
    let yourTurnModelSelectedPublishRelay = PublishRelay<YourTurnCellViewModel>()

    let homeNavigationBarViewModel = HomeNavigationBarViewModel()
    var dataSource: RxTableViewSectionedReloadDataSource<HomeSectionModel>!

    init() {
        setupDataSource()
    }

    private func setupDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<HomeSectionModel>(configureCell: { (dataSource, tableView, indexPath, viewModel) -> UITableViewCell in
            switch viewModel {
            case let homePendingViewModel as HomePendingViewModel:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PendingTableViewCell") as? PendingTableViewCell else { return UITableViewCell() }

                cell.bind(homePendingViewModel)

                return cell

            case let yourTurnViewModel as YourTurnCellViewModel:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourTurnTableViewCell") as? YourTurnTableViewCell else { return UITableViewCell() }

                cell.bind(yourTurnViewModel)

                return cell
            default:
                return UITableViewCell()
            }
        })
    }
}
