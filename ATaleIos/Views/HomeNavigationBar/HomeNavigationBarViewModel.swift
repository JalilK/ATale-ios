//
//  HomeNavigationBarViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum TaleFilterState {
    case active
    case completed
}

class HomeNavigationBarViewModel {
    private let taleFilterStateBehaviorRelay = BehaviorRelay<TaleFilterState>(value: .active)

    lazy var taleFilterStateDriver: Driver<TaleFilterState> = {
        taleFilterStateBehaviorRelay.asDriver()
    }()

    let activeButtonTappedPublishRelay = PublishRelay<Void>()
    let completedButtonTappedPublishRelay = PublishRelay<Void>()
    let newFableButtonPublishRelay = PublishRelay<Void>()

    let disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        completedButtonTappedPublishRelay
            .map { _ in .completed }
            .bind(to: taleFilterStateBehaviorRelay)
            .disposed(by: disposeBag)

        activeButtonTappedPublishRelay
            .map { _ in .active }
            .bind(to: taleFilterStateBehaviorRelay)
            .disposed(by: disposeBag)
    }
}
