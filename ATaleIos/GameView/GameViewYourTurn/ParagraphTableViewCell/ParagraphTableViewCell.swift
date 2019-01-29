//
//  ParagraphTableViewCell.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/28/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ParagraphTableViewCell: UITableViewCell {
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paragraphTextLabel: UILabel!

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

    func bind(to viewModel: ParagraphCellViewModel) {
        viewModel.playerImageDriver
            .drive(playerImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.playerNameTextDriver
            .drive(playerNameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.dateStringDriver
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.paragraphTextDriver
            .drive(paragraphTextLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
