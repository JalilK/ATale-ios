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
import FirebaseAuth
import RxFirebase
import RxOptional

class NewTaleViewModel {
    private let currentFirebaseUserBehaviorRelay: BehaviorRelay<User?>
    private let firebaseAuth = Auth.auth()

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

    lazy var currentUserImageDriver: Driver<UIImage> = {
        currentFirebaseUserBehaviorRelay
            .filterNil()
            .map { $0.photoURL }
            .filterNil()
            .map { URLRequest(url: $0) }
            .flatMap {
                URLSession.shared.rx
                    .data(request: $0)
                    .subscribeOn(MainScheduler.instance)
            }
            .map { UIImage(data: $0) ?? UIImage() }
            .asDriver(onErrorJustReturn: UIImage())
    }()

    init() {
        currentFirebaseUserBehaviorRelay = BehaviorRelay<User?>(value: firebaseAuth.currentUser)
    }
}
