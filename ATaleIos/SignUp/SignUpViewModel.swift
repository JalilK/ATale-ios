//
//  SignUpViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 11/25/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FacebookLogin
import FacebookCore
import Action
import FirebaseAuth

class SignUpViewModel {
    lazy var titleTextDriver: Driver<NSAttributedString> = {
        Driver.just(getAttirbutedTitleString())
    }()

    lazy var loginSuccessDriver: Driver<UIViewController> = {
        facebookButtonAction.executionObservables
            .flatMap { $0 }
            .map { _ in
                 return UIStoryboard(name: "HomeScreenViewController", bundle: nil).instantiateInitialViewController() ?? UIViewController()
            }
            .asDriver(onErrorJustReturn: UIViewController())
    }()

    let facebookButtonAction: Action<Void, AuthCredential> = Action<Void, AuthCredential> {
        return FacebookLoginService.login()
    }

    private func getAttirbutedTitleString() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "ATale", attributes: [
            .font: UIFont(name: "Avenir-Heavy", size: 80.0)!,
            .foregroundColor: UIColor(red: 24.0 / 255.0, green: 38.0 / 255.0, blue: 65.0 / 255.0, alpha: 1.0)
            ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 1.0, green: 91.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0), range: NSRange(location: 1, length: 1))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 1.0, green: 183.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0), range: NSRange(location: 2, length: 1))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.0, green: 121.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0), range: NSRange(location: 3, length: 1))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 108.0 / 255.0, green: 0.0, blue: 72.0 / 255.0, alpha: 1.0), range: NSRange(location: 4, length: 1))

        return attributedString
    }
}
