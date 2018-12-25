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
        tableView.backgroundColor = UIColor.cream
        tableView.register(UINib(nibName: "PendingTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingTableViewCell")

        view.backgroundColor = UIColor.cream
    }

    private func setupBindings() {
        viewModel.homeCellViewModelsObservable.bind(to: tableView.rx.items(cellIdentifier: "PendingTableViewCell")) { (_: Int, element: HomePendingViewModel, cell: PendingTableViewCell) in
            cell.bind(element)
        }.disposed(by: disposeBag)
    }
}
