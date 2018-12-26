//
//  SelectColorViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/26/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SelectColorViewModel {
    private var colorBehaviorRelay: BehaviorRelay<UIColor>!

    lazy var selectedColorDriver: Driver<UIColor> = {
        colorBehaviorRelay.asDriver()
    }()
    lazy var viewTappedDriver: Driver<UIColor> = {
        viewTappedPublishRelay
            .map { [unowned self] _ in return self.colorBehaviorRelay.value }
            .asDriver(onErrorJustReturn: UIColor.clear)
    }()

    let viewTappedPublishRelay = PublishRelay<UITapGestureRecognizer>()

    init(color: UIColor) {
        colorBehaviorRelay = BehaviorRelay<UIColor>(value: color)
    }
}
