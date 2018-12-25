//
//  TurnTableViewCell.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/24/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TurnTableViewCell: UITableViewCell {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var taleTitleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var turnLabel: UILabel!

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func bind(_ viewModel: TurnTableViewCellViewModel) {
        viewModel.selectedColorDriver
            .drive(selectedColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.titleDriver
            .drive(taleTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.userImageDriver
            .drive(userImageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func setupViews() {
    }
}
