//
//  NewTaleViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/25/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IHKeyboardAvoiding

class NewTaleViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var selectColorViews: [SelectColorView]!
    @IBOutlet weak var currentUserPlayerImageView: UIImageView!
    @IBOutlet var playerImageViews: [UIImageView]!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    private let continueBarButton: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: .done, target: nil, action: nil)
    
    let disposeBag = DisposeBag()
    let viewModel = NewTaleViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        KeyboardAvoiding.avoidingView = characterCountLabel

        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.backgroundColor: UIColor.cream,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ]
        navigationItem.setRightBarButton(continueBarButton, animated: false)

        selectedColorView.backgroundColor = UIColor.darkTeal
        characterCountLabel.textColor = UIColor.gray

        currentUserPlayerImageView.layer.cornerRadius = currentUserPlayerImageView.frame.height / 2
        currentUserPlayerImageView.layer.masksToBounds = false
        currentUserPlayerImageView.clipsToBounds = true

        playerImageViews.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.layer.masksToBounds = false
            $0.clipsToBounds = true
        }
    }

    private func setupBindings() {
        selectColorViews
            .enumerated()
            .forEach {
                $0.element.bind(viewModel.selectColorViewModels[$0.offset])

                viewModel.selectColorViewModels[$0.offset].viewTappedDriver
                    .drive(selectedColorView.rx.backgroundColor)
                    .disposed(by: disposeBag)
        }

        titleTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.titleTextFieldTextPublishRelay)
            .disposed(by: disposeBag)

        continueBarButton.rx.tap
            .bind(to: viewModel.continueButtonTappedPublishRelay)
            .disposed(by: disposeBag)

        viewModel.currentUserImageDriver
            .drive(currentUserPlayerImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.characterCountTextDriver
            .drive(characterCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.titleTextFieldTextDriver
            .drive(titleTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
