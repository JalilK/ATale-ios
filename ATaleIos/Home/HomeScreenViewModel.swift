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
//    private let sections = [
//        HomeSectionModel(header: "Pending", items: [HomePendingViewModel()]),
//        HomeSectionModel(header: "Your Turn", items: [TurnTableViewCellViewModel]())
//    ]
    private let firestStoreServiceBehaviorRelay = BehaviorRelay<FirebaseFirestoreSevice>(value: FirebaseFirestoreSevice())
    private let pendingViewModelSelectedPublishRelay = PublishRelay<PendingCollectionCellViewModel>()

    private lazy var pendingTalesObservable: Observable<HomeSectionModel> = {
        viewDidAppearPublishRelay
            .map { [unowned self] _ in self.firestStoreServiceBehaviorRelay.value }
            .flatMapLatest { $0.getPendingTales().take(1) }
            .filterEmpty()
            .map {
                let homePendingViewModel = HomePendingViewModel(pendingTales: $0)
                homePendingViewModel.viewModelSelectedPublishRelay
                    .bind(to: self.pendingViewModelSelectedPublishRelay)
                    .disposed(by: homePendingViewModel.disposeBag)

                return HomeSectionModel(header: "Pending", items: [homePendingViewModel])
            }
    }()

    lazy var homeCellViewModelsObservable: Observable<[HomeSectionModel]> = {
        Observable.combineLatest([pendingTalesObservable])
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

    let viewDidAppearPublishRelay = PublishRelay<Void>()

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
            case let turnViewModel as TurnTableViewCellViewModel:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TurnTableViewCell") as? TurnTableViewCell else { return UITableViewCell() }

                cell.bind(turnViewModel)

                return cell
            default:
                return UITableViewCell()
            }
        })
    }    
}
