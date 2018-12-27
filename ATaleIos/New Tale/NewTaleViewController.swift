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

class NewTaleViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var selectColorViews: [SelectColorView]!
    @IBOutlet weak var currentUserPlayerImageView: UIImageView!
    @IBOutlet var playerImageViews: [UIImageView]!
    
    let disposeBag = DisposeBag()
    let viewModel = NewTaleViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.backgroundColor: UIColor.cream,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ]

        selectedColorView.backgroundColor = UIColor.darkTeal

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

        viewModel.currentUserImageDriver
            .drive(currentUserPlayerImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
