//
//  PendingCollectionViewCell.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PendingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var inviteLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func bind(_ viewModel: PendingCollectionCellViewModel) {
        viewModel.selectedColorDriver
            .drive(selectedColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.userImageDriver
            .drive(userImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.inviteTextDriver
            .drive(inviteLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        acceptButton.setTitleColor(UIColor.teal, for: .normal)
        declineButton.setTitleColor(UIColor.greyishBrown, for: .normal)
    }
}
