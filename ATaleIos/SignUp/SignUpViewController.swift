//
//  SignUpViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 11/25/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class SignUpViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectToFacebookButton: UIButton!

    private let disposeBag = DisposeBag()

    let viewModel: SignUpViewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        connectToFacebookButton.backgroundColor = UIColor.navy
        view.backgroundColor = UIColor.cream
    }

    private func setupBindings() {
        viewModel.titleTextDriver
            .drive(titleLabel.rx.attributedText)
            .disposed(by: disposeBag)

        viewModel.loginSuccessDriver
            .drive(rx.presentViewController)
            .disposed(by: disposeBag)

        connectToFacebookButton.rx.bind(to: viewModel.facebookButtonAction) { _ in return }
    }
}
