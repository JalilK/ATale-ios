//
//  HomeScreenViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeScreenViewModel {
    let homeNavigationBarViewModel = HomeNavigationBarViewModel()

    private let homeCellViewModels = [HomePendingViewModel()]

    lazy var homeCellViewModelsObservable: Observable<[HomePendingViewModel]> = {
        Observable.just(homeCellViewModels)
    }()

    // Mark: - HomeNavigationBar Observables
    
}
