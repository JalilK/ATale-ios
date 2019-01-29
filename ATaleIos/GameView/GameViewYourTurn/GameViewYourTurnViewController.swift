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
import IHKeyboardAvoiding

class GameViewYourTurnViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var gameStatusContainerView: UIView!
    @IBOutlet weak var taleTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var playerImageViews: [UIImageView]!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var newLineAccessoryView: NewLineAccessoryView!
    
    private let disposeBag = DisposeBag()

    var viewModel: GameViewYourTurnViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        KeyboardAvoiding.avoidingView = newLineAccessoryView
        view.backgroundColor = UIColor.cream

        taleTitleLabel.textColor = UIColor.greyishBrown
        textField.textColor = UIColor.greyishBrown

        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ParagraphTableViewCell", bundle: nil), forCellReuseIdentifier: "ParagraphTableViewCell")
        tableView.backgroundColor = UIColor.cream
    }

    private func setupBindings() {
        guard let viewModel = viewModel else { return }

        newLineAccessoryView.bind(viewModel: viewModel.newLineAccessoryViewModel)

        textField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.lineTextPublishRelay)
            .disposed(by: disposeBag)

        viewModel.submitNewLineDriver
            .drive(rx.goToHomeViewController)
            .disposed(by: disposeBag)

        viewModel.paragraphsObservable
            .bind(to: tableView.rx.items(cellIdentifier: "ParagraphTableViewCell", cellType: ParagraphTableViewCell.self))(viewModel.cellConfiguration).disposed(by: disposeBag)

        viewModel.taleColorDriver
            .drive(selectedColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.taleTitleDriver
            .drive(taleTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.roundTextDriver
            .drive(roundLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.playerImagesDriver
            .drive(rx.playerImages)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: GameViewYourTurnViewController {
    fileprivate var playerImages: Binder<[UIImage]> {
        return Binder(self.base) { viewController, images in
            images.enumerated().forEach {
                viewController.playerImageViews[$0.offset].image = $0.element
            }
        }
    }
}
