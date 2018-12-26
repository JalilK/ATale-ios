//
//  HomeNavigationBar.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class HomeNavigationBar: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var newTaleButton: UIButton!
    @IBOutlet weak var selectionIndicatorView: UIView!

    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func bind(viewModel: HomeNavigationBarViewModel) {
        newTaleButton.rx.tap
            .bind(to: viewModel.newFableButtonPublishRelay)
            .disposed(by: disposeBag)
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("HomeNavigationBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor.cream
        contentView.backgroundColor = UIColor.cream
        activeButton.setTitleColor(UIColor.greyishBrown, for: .normal)
        completedButton.setTitleColor(UIColor.greyishBrown, for: .normal)
        newTaleButton.setTitleColor(UIColor.teal, for: .normal)

        selectionIndicatorView.backgroundColor = UIColor.teal
        selectionIndicatorView.layer.cornerRadius = selectionIndicatorView.frame.height / 2
    }
}
