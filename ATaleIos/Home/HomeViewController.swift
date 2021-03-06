//
//  HomeViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    @IBOutlet weak var homeNavigationBar: HomeNavigationBar!
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()
    private let viewModel = HomeScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    private func setupViews() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.cream
        tableView.register(UINib(nibName: "HomeSectionHeaderCell", bundle:  nil), forCellReuseIdentifier: "HomeSectionHeaderCell")
        tableView.register(UINib(nibName: "YourTurnTableViewCell", bundle: nil), forCellReuseIdentifier: "YourTurnTableViewCell")
        tableView.register(UINib(nibName: "CompletedTableViewCell", bundle: nil), forCellReuseIdentifier: "CompletedTableViewCell")
        tableView.register(UINib(nibName: "PendingTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingTableViewCell")

        view.backgroundColor = UIColor.cream
    }

    private func setupBindings() {
        homeNavigationBar.bind(viewModel: viewModel.homeNavigationBarViewModel)

        rx.viewDidAppear
            .map { _ in return () }
            .bind(to: viewModel.viewDidAppearPublishRelay)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(HomeCellViewModelType.self)
            .bind(to: viewModel.homeSectionViewModelSelectedPublishRelay)
            .disposed(by: disposeBag)

        viewModel.homeCellViewModelsObservable
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)

        viewModel.homeCellViewModelsObservable
            .take(1)
            .map { _ in false }
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.newTaleDriver
            .drive(rx.pushToNavigationController)
            .disposed(by: disposeBag)

        viewModel.yourTurnGameViewDriver
            .drive(rx.pushToNavigationController)
            .disposed(by: disposeBag)

        viewModel.pendingGameViewDriver
            .drive(rx.pushToNavigationController)
            .disposed(by: disposeBag)

        viewModel.completedGameViewDriver
            .drive(rx.pushToNavigationController)
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableCell(withIdentifier: "HomeSectionHeaderCell") as? HomeSectionHeaderCell else { return UIView() }
        let view = UIView()
        view.addSubview(headerView)

        headerView.titleLabel.text = viewModel.dataSource.sectionModels[section].header

        return view
    }
}
