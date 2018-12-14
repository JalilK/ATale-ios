//
//  FacebookLoginService.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/4/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore
import RxSwift

class FacebookLoginService {
    private let loginManager: LoginManager = LoginManager()

    func login(with readPermissions: [ReadPermission] = [.publicProfile]) -> Observable<AccessToken> {
        return Observable<AccessToken>.create { observer in
            self.loginManager.logIn(readPermissions: readPermissions, viewController: nil) { result in
                switch result {
                case .success(_, _, let token):
                    observer.onNext(token)
                    observer.onCompleted()
                case .cancelled:
                    print("Cancelled Login")
                    observer.onCompleted()
                case .failed(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }
}
