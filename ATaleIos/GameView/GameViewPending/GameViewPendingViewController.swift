//
//  GameViewPendingViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/9/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import UIKit

class GameViewPendingViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var taleTitleLabel: UILabel!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorInviteLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        declineButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        declineButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        declineButton.layer.shadowOpacity = 1.0
        declineButton.layer.shadowRadius = 0.0
        declineButton.layer.masksToBounds = false
        declineButton.layer.cornerRadius = 4.0
    }
}
