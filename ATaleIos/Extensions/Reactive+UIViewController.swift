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

    var pushToNavigationController: Binder<UIViewController> {
        return Binder(self.base) { parent, viewController in
            parent.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    var popFromNavigationController: Binder<Void> {
        return Binder(self.base) { parent, _ in
            parent.navigationController?.popViewController(animated: true)
        }
    }

    var goToHomeViewController: Binder<Void> {
        return Binder(self.base) { parent, _ in
            parent.navigationController?.popToRootViewController(animated: true)
        }
    }

    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
