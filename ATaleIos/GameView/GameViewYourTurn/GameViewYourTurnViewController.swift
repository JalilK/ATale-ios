//
//  GameViewYourTurnViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/25/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewYourTurnViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var gameStatusContainerView: UIView!
    @IBOutlet weak var taleTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!

    var viewModel = GameViewYourTurnViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.cream

        taleTitleLabel.textColor = UIColor.greyishBrown
        textField.textColor = UIColor.greyishBrown
    }
}
