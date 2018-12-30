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
import RxGesture
import IHKeyboardAvoiding

class NewTaleViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var selectColorViews: [SelectColorView]!
    @IBOutlet weak var currentUserPlayerImageView: UIImageView!
    @IBOutlet weak var playerImageViewsContainerStackView: UIStackView!
    @IBOutlet var playerImageViews: [UIImageView]!
    @IBOutlet weak var characterCountLabel: UILabel!

    private let backBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "backChevron") ?? UIImage(), style: .done, target: nil, action: nil)
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

        view.backgroundColor = UIColor.cream

        navigationController?.navigationBar.barTintColor = UIColor.cream
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrown,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ]

        continueBarButton.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.teal,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ], for: .normal)
        continueBarButton.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ], for: .disabled)

        navigationItem.setRightBarButton(continueBarButton, animated: false)
        navigationItem.setLeftBarButton(backBarButton, animated: false)

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

                viewModel.selectColorViewModels[$0.offset].viewTappedColorDriver
                    .drive(selectedColorView.rx.backgroundColor)
                    .disposed(by: disposeBag)

                viewModel.selectColorViewModels[$0.offset].viewTappedViewModelDriver
                    .asObservable()
                    .bind(to: viewModel.colorViewModelSelectedPublishRelay)
                    .disposed(by: disposeBag)
        }

        playerImageViewsContainerStackView.rx.tapGesture()
            .when(.ended)
            .bind(to: viewModel.playerImageViewsContainerStackViewTappedPublishRelay)
            .disposed(by: disposeBag)

        titleTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.titleTextFieldTextPublishRelay)
            .disposed(by: disposeBag)

        continueBarButton.rx.tap
            .bind(to: viewModel.continueButtonTappedPublishRelay)
            .disposed(by: disposeBag)

        backBarButton.rx.tap
            .bind(to: rx.popFromNavigationController)
            .disposed(by: disposeBag)

        viewModel.firstLineDriver
            .drive(rx.pushToNavigationController)
            .disposed(by: disposeBag)

        viewModel.selectedPlayersDriver
            .drive(rx.selectedPlayers)
            .disposed(by: disposeBag)

        viewModel.continueButtonEnabledDriver
            .drive(continueBarButton.rx.isEnabled)
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

        viewModel.invitePlayersDriver
            .drive(rx.pushToNavigationController)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: NewTaleViewController {
    var selectedPlayers: Binder<[PlayerViewModel]> {
        return Binder(self.base) { viewController, viewModels in
            viewModels.enumerated().forEach {
                $0.element.playerSharedImageDriver
                    .drive(viewController.playerImageViews[$0.offset].rx.image)
                    .disposed(by: $0.element.disposeBag)
            }

            for i in viewModels.count..<viewController.playerImageViews.count {
                viewController.playerImageViews[i].image = i < 2 ? UIImage(named: "friend") ?? UIImage() : UIImage(named: "friend-1") ?? UIImage()
            }
        }
    }
}
