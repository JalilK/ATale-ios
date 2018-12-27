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
import RxFirebase
import FirebaseAuth

final class FacebookLoginService {
    private static let loginManager: LoginManager = LoginManager()

    static func login(with readPermissions: [ReadPermission] = [.publicProfile]) -> Observable<AuthCredential> {
        return Observable<AuthCredential>.create { observer in
            self.loginManager.logIn(readPermissions: readPermissions, viewController: nil) { result in
                switch result {
                case .success(_, _, let token):
                    let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)

                    Auth.auth().signInAndRetrieveData(with: credential, completion: { result, error in
                        if let error = error {
                            observer.onError(error)
                        } else {
                            observer.onNext(credential)
                            observer.onCompleted()
                        }
                    })
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
