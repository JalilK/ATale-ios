//
//  HomePendingViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomePendingViewModel: HomeCellViewModelType {
    private let pendingCellViewModelsBehaviorRelay: BehaviorRelay<[PendingCollectionCellViewModel]>!

    lazy var pendingCellViewModelsObservable: Observable<[PendingCollectionCellViewModel]> = {
        pendingCellViewModelsBehaviorRelay.asObservable()
    }()

    init(pendingTales: [TaleFirestoreModel]) {
        pendingCellViewModelsBehaviorRelay = BehaviorRelay<[PendingCollectionCellViewModel]>(value: pendingTales.map { PendingCollectionCellViewModel(pendingTaleModel: $0) })
    }
}
