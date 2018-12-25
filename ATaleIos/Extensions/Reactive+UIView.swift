//
//  Reactive+UIView.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/23/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }
}
