//
//  Reactive+UIViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var presentViewController: Binder<UIViewController> {
        return Binder(self.base) { parent, viewController in
            parent.present(viewController, animated: true, completion: nil)
        }
    }
}
