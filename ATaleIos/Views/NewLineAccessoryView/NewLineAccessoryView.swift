//
//  NewLineAccessoryView.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/30/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewLineAccessoryView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var gifButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!

    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func bind(viewModel: NewLineAccessoryViewModel) {
        selectButton.rx.tap
            .bind(to: viewModel.selectButtonTappedPublishRelay)
            .disposed(by: disposeBag)

        viewModel.textCountStringDriver
            .drive(characterCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.selectButtonEnabledDriver
            .drive(rx.createTaleEnabled)
            .disposed(by: disposeBag)
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("NewLineAccessoryView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension Reactive where Base: NewLineAccessoryView {
    var createTaleEnabled: Binder<Bool> {
        return Binder(self.base) { view, enabled in
            view.selectButton.setImage(enabled ? UIImage(named: "selectEnabled") ?? UIImage() : UIImage(named: "selectDisabled") ?? UIImage(), for: .normal)
            view.characterCountLabel.textColor = enabled ? UIColor.teal : UIColor.lightGray
        }
    }
}
