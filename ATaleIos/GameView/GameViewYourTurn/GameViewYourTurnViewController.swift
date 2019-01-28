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

    private let disposeBag = DisposeBag()

    var viewModel: GameViewYourTurnViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.cream

        taleTitleLabel.textColor = UIColor.greyishBrown
        textField.textColor = UIColor.greyishBrown
    }

    private func setupBindings() {
        guard let viewModel = viewModel else { return }

        viewModel.taleColorDriver
            .drive(selectedColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.taleTitleDriver
            .drive(taleTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
