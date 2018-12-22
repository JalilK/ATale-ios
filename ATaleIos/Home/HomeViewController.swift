//
//  HomeViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var homeNavigationBar: HomeNavigationBar!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel = HomeScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.cream
        tableView.isHidden = true
    }
}
