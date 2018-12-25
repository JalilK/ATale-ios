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
    let pendingCellViewModels = [
        PendingCollectionCellViewModel(pendingTaleModel: PendingTaleModel(selectedColor: UIColor.teal, title: "A tale of two cities", userImage: UIImage(), senderUsername: "Rex Raptor")),
        PendingCollectionCellViewModel(pendingTaleModel: PendingTaleModel(selectedColor: UIColor.greyishBrown, title: "The Forlorn", userImage: UIImage(), senderUsername: "Trent"))
    ]
}
