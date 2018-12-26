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

    let disposeBag = DisposeBag()
    let viewModel = NewTaleViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        selectedColorView.backgroundColor = UIColor.darkTeal
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
    }
}
