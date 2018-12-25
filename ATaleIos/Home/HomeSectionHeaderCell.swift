//
//  HomeSectionHeaderCell.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/25/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit

class HomeSectionHeaderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor.cream
        bottomView.backgroundColor = UIColor.teal
    }
}
