//
//  ParagraphCellViewModel.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/28/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ParagraphCellViewModel {
    private let paragraphModelBehaviorRelay: BehaviorRelay<TaleFirestoreParagraph>!

    lazy var playerImageDriver: Driver<UIImage> = {
        paragraphModelBehaviorRelay
            .map { $0.creatorImageURL }
            .filterNil()
            .map { URLRequest(url: $0) }
            .flatMapLatest {
                URLSession.shared.rx
                    .data(request: $0)
                    .subscribeOn(MainScheduler.instance)
            }
            .map { UIImage(data: $0) ?? UIImage() }
            .asDriver(onErrorJustReturn: UIImage())
    }()

    lazy var playerNameTextDriver: Driver<String> = {
        paragraphModelBehaviorRelay
            .map { $0.creatorUsername }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var dateStringDriver: Driver<String> = {
        paragraphModelBehaviorRelay
            .map { $0.date.toString(withFormat: .HHmm) }
            .asDriver(onErrorJustReturn: "")
    }()

    lazy var paragraphTextDriver: Driver<String> = {
        paragraphModelBehaviorRelay
            .map { $0.paragraphText }
            .asDriver(onErrorJustReturn: "")
    }()

    init(with paragraph: TaleFirestoreParagraph) {
        paragraphModelBehaviorRelay = BehaviorRelay<TaleFirestoreParagraph>(value: paragraph)
    }
}
