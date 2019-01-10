//
//  PendingTableViewCell.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/22/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PendingTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bind(_ viewModel: HomePendingViewModel) {
        collectionView.rx
            .modelSelected(PendingCollectionCellViewModel.self)
            .bind(to: viewModel.viewModelSelectedPublishRelay)
            .disposed(by: disposeBag)

        viewModel.pendingCellViewModelsObservable.bind(to: collectionView.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PendingCollectionViewCell", for: indexPath) as! PendingCollectionViewCell

            cell.bind(element)

            return cell
            }
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        collectionView.backgroundColor = UIColor.cream
        collectionView.register(UINib(nibName: "PendingCollectionViewHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PendingCollectionViewHeader")
        collectionView.register(UINib(nibName: "PendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PendingCollectionViewCell")
    }
}
