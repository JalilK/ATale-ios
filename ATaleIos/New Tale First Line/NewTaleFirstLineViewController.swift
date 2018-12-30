//
//  NewTaleFirstLineViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/30/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewTaleFirstLineViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taleTitleLabel: UILabel!
    @IBOutlet weak var firstLineTextField: UITextField!

    private lazy var firstLineAccessoryView: NewLineAccessoryView = {
        let view = NewLineAccessoryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 42))
        return view
    }()

    private let backBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "backChevron") ?? UIImage(), style: .done, target: nil, action: nil)
    private let createBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: nil, action: nil)

    var viewModel = NewTaleFirstLineViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        navigationController?.navigationBar.barTintColor = UIColor.cream
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrown,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ]

        navigationItem.setLeftBarButton(backBarButton, animated: true)

        createBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.teal,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ], for: .normal)
        createBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ], for: .disabled)

        firstLineTextField.inputAccessoryView = firstLineAccessoryView
        firstLineTextField.backgroundColor = UIColor.cream

        titleLabel.textColor = UIColor.greyishBrown
    }

    private func setupBindings() {
        firstLineAccessoryView.bind(viewModel: viewModel.newLineAccessoryViewModel)

        firstLineTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.firstLineTextFieldTextPublishRelay)
            .disposed(by: disposeBag)

        backBarButton.rx.tap
            .bind(to: rx.popFromNavigationController)
            .disposed(by: disposeBag)

        viewModel.taleCreatedDriver
            .drive(rx.goToHomeViewController)
            .disposed(by: disposeBag)

        viewModel.selectedColorDriver
            .drive(selectedColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.taleTitleDriver
            .drive(taleTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.newLineAccessoryViewModel.selectButtonEnabledDriver
            .drive(createBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
