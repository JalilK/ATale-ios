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
    let homeNavigationBarViewModel = HomeNavigationBarViewModel()
    var dataSource: RxTableViewSectionedReloadDataSource<HomeSectionModel>!

    private let sections = [
        HomeSectionModel(header: "Pending", items: [HomePendingViewModel()]),
        HomeSectionModel(header: "Your Turn", items: [
            TurnTableViewCellViewModel(taleModel: TaleModel(selectedColor: UIColor.gray, title: "Game of Thrones", userImage: UIImage(), creatorUsername: "Steve")),
            TurnTableViewCellViewModel(taleModel: TaleModel(selectedColor: UIColor.gray, title: "DragonStone", userImage: UIImage(), creatorUsername: "Bob"))
            ])
    ]

    lazy var homeCellViewModelsObservable: Observable<[HomeSectionModel]> = {
        Observable.just(sections)
    }()
    lazy var newTaleDriver: Driver<UIViewController> = {
        homeNavigationBarViewModel.newFableButtonPublishRelay.map {
            let vc = (UIStoryboard(name: "NewTaleViewController", bundle: nil).instantiateInitialViewController() ?? UIViewController())
            vc.title = "New Tale"

            return vc
        }
        .asDriver(onErrorJustReturn: UIViewController())
    }()

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
