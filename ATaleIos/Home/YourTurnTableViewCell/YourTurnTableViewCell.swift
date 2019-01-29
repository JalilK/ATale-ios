//
//  YourTurnTableViewCell.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/25/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class YourTurnTableViewCell: UITableViewCell {
    @IBOutlet weak var taleColorView: UIView!
    @IBOutlet weak var taleTitleLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    private func setupViews() {
        backgroundColor = UIColor.cream
        contentView.backgroundColor = UIColor.cream
    }

    func bind(_ viewModel: YourTurnCellViewModel) {
        viewModel.taleColorDriver
            .drive(taleColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.taleTitleDriver
            .drive(taleTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.playerImageDriver
            .drive(playerImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
