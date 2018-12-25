//
//  TurnTableViewCellViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/24/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TurnTableViewCellViewModel: HomeCellViewModelType {
    private let taleModelBehaviorRelay: BehaviorRelay<TaleModel>!

    lazy var selectedColorDriver: Driver<UIColor> = {
        taleModelBehaviorRelay
            .map { $0.selectedColor }
            .asDriver(onErrorJustReturn: UIColor.clear)
    }()

    lazy var titleDriver: Driver<String> = {
        taleModelBehaviorRelay
            .map { $0.title }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var userImageDriver: Driver<UIImage> = {
        taleModelBehaviorRelay
            .map { $0.userImage }
            .asDriver(onErrorJustReturn: UIImage())
    }()

    init(taleModel: TaleModel) {
        taleModelBehaviorRelay = BehaviorRelay<TaleModel>(value: taleModel)
    }
}
