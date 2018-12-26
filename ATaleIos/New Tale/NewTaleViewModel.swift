//
//  NewTaleViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/26/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NewTaleViewModel {
    let selectColorViewModels = [
        SelectColorViewModel(color: UIColor.darkTeal),
        SelectColorViewModel(color: UIColor.mustard),
        SelectColorViewModel(color: UIColor.orange),
        SelectColorViewModel(color: UIColor.pink),
        SelectColorViewModel(color: UIColor.green),
        SelectColorViewModel(color: UIColor.violet),
        SelectColorViewModel(color: UIColor.purple),
        SelectColorViewModel(color: UIColor.navy)
    ]
}
