//
//  NewLineAccessoryViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/30/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NewLineAccessoryViewModel {
    let disposeBag = DisposeBag()

    private let textCountBehaviorRelay = BehaviorRelay<Int>(value: 0)
    private let maxCharacterCount = 200

    lazy var textCountStringDriver: Driver<String> = {
        textCountBehaviorRelay
            .map { [unowned self] in "\($0)/\(self.maxCharacterCount)" }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var selectButtonEnabledDriver: Driver<Bool> = {
        textCountBehaviorRelay
            .map { $0 > 0 && $0 <= 200 }
            .asDriver(onErrorJustReturn: false)
    }()

    let cameraButtonTappedPublishRelay = PublishRelay<Void>()
    let gifButtonTappedPublishRelay = PublishRelay<Void>()
    let selectButtonTappedPublishRelay = PublishRelay<Void>()
    let lineTextPublishRelay = PublishRelay<String>()

    init() {
        lineTextPublishRelay
            .map { $0.count }
            .bind(to: textCountBehaviorRelay)
            .disposed(by: disposeBag)
    }
}
