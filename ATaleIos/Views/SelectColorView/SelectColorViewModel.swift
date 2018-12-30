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

public enum TaleColor: String {
    case darkTeal = "dark-teal"
    case orange = "orange"
    case green = "green"
    case purple = "purple"
    case mustard = "mustard"
    case pink = "pink"
    case violet = "violet"
    case navy = "navy"

    var color: UIColor {
        switch self {
        case .darkTeal:
            return UIColor.darkTeal
        case .orange:
            return UIColor.orange
        case .green:
            return UIColor.green
        case .purple:
            return UIColor.purple
        case .mustard:
            return UIColor.mustard
        case .pink:
            return UIColor.pink
        case .violet:
            return UIColor.violet
        case .navy:
            return UIColor.navy
        }
    }
}

class SelectColorViewModel {
    private var taleColorBehaviorRelay: BehaviorRelay<TaleColor>!

    lazy var taleColorObservable: Observable<TaleColor> = {
        taleColorBehaviorRelay.asObservable()
    }()

    lazy var selectedColorDriver: Driver<UIColor> = {
        taleColorBehaviorRelay
            .map { $0.color }
            .asDriver(onErrorJustReturn: UIColor.clear)
    }()

    lazy var viewTappedColorDriver: Driver<UIColor> = {
        viewTappedPublishRelay
            .flatMapLatest { _ in self.taleColorObservable.take(1) }
            .map { $0.color }
            .asDriver(onErrorJustReturn: UIColor.clear)
    }()

    lazy var viewTappedViewModelDriver: Driver<SelectColorViewModel> = {
        viewTappedPublishRelay
            .map { _ in return self }
            .asDriver(onErrorJustReturn: self)
    }()

    let viewTappedPublishRelay = PublishRelay<UITapGestureRecognizer>()

    init(color: TaleColor) {
        taleColorBehaviorRelay = BehaviorRelay<TaleColor>(value: color)
    }
}
