//
//  GameViewPendingViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/9/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewPendingViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var taleTitleLabel: UILabel!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorInviteLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!

    let disposeBag = DisposeBag()
    var viewModel: GameViewPendingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.cream

        declineButton.backgroundColor = UIColor.white
        declineButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        declineButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        declineButton.layer.shadowOpacity = 1.0
        declineButton.layer.shadowRadius = 4
        declineButton.layer.masksToBounds = false
        declineButton.layer.cornerRadius = 4.0
        declineButton.setTitle("Decline", for: .normal)
        declineButton.setTitleColor(UIColor.orange, for: .normal)

        acceptButton.backgroundColor = UIColor.white
        acceptButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        acceptButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        acceptButton.layer.shadowOpacity = 1.0
        acceptButton.layer.shadowRadius = 4
        acceptButton.layer.masksToBounds = false
        acceptButton.layer.cornerRadius = 4.0
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(UIColor.teal, for: .normal)
    }

    private func setupBindings() {
        viewModel?.selectedColorDriver
            .drive(selectedColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel?.taleTitleDriver
            .drive(taleTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel?.taleCreatorImageDriver
            .drive(creatorImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel?.taleInviteTextDriver
            .drive(creatorInviteLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
