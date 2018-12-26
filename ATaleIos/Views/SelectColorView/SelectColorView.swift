//
//  SelectColorView.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/26/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class SelectColorView: UIView {
    let disposeBag = DisposeBag()

    func bind(_ viewModel: SelectColorViewModel) {
        rx.tapGesture()
            .when(.ended)
            .bind(to: viewModel.viewTappedPublishRelay)
            .disposed(by: disposeBag)

        viewModel.selectedColorDriver
            .drive(rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
