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

    private func setupViews() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.backgroundColor = UIColor.cream
        tableView.register(UINib(nibName: "HomeSectionHeaderCell", bundle:  nil), forCellReuseIdentifier: "HomeSectionHeaderCell")
        tableView.register(UINib(nibName: "TurnTableViewCell", bundle: nil), forCellReuseIdentifier: "TurnTableViewCell")
        tableView.register(UINib(nibName: "PendingTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingTableViewCell")

        view.backgroundColor = UIColor.cream
    }

    private func setupBindings() {
        viewModel.homeCellViewModelsObservable.bind(to: tableView.rx.items(dataSource: viewModel.dataSource)).disposed(by: disposeBag)
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
