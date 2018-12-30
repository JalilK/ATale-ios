//
//  InvitePlayersTableViewCell.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/27/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InvitePlayersTableViewCell: UITableViewCell {
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    func bind(viewModel: PlayerViewModel) {
        viewModel.playerSharedImageDriver
            .drive(playerImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.playerNameTextDriver
            .drive(playerNameLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        contentView.backgroundColor = UIColor.cream
        separatorView.backgroundColor = UIColor.lightGray

        playerImageView.layer.cornerRadius = playerImageView.frame.height / 2
        playerImageView.layer.masksToBounds = false
        playerImageView.clipsToBounds = true
    }
}
