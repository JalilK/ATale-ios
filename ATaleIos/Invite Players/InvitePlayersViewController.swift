//
//  InvitePlayersViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 12/27/18.
//  Copyright © 2018 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InvitePlayersViewController: UIViewController {
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentUserPlayerImageView: UIImageView!
    @IBOutlet var playersImageViews: [UIImageView]!
    @IBOutlet weak var tableView: UITableView!

    private let backBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "backChevron") ?? UIImage(), style: .done, target: nil, action: nil)

    let disposeBag = DisposeBag()
    var viewModel = InvitePlayersViewModel()

    private lazy var searchTextFieldRightView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 31, height: 15))
        let imageView = UIImageView(frame: CGRect(x: 16, y: 0, width: 15, height: 15))
        imageView.image = UIImage(named: "searchIcon") ?? UIImage()
        imageView.center = view.center

        view.addSubview(imageView)

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        navigationController?.navigationBar.barTintColor = UIColor.cream
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrown,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!
        ]

        navigationItem.setLeftBarButton(backBarButton, animated: false)

        view.backgroundColor = UIColor.cream
        searchContainerView.backgroundColor = UIColor.cream
        tableView.backgroundColor = UIColor.cream

        tableView.register(UINib(nibName: "InvitePlayersTableViewCell", bundle: nil), forCellReuseIdentifier: "InvitePlayersTableViewCell")

        searchTextField.clipsToBounds = true
        searchTextField.leftView = searchTextFieldRightView
        searchTextField.leftViewMode = .always

        currentUserPlayerImageView.layer.cornerRadius = currentUserPlayerImageView.frame.height / 2
        currentUserPlayerImageView.layer.masksToBounds = false
        currentUserPlayerImageView.clipsToBounds = true

        playersImageViews.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.layer.masksToBounds = false
            $0.clipsToBounds = true
        }
    }

    private func setupBindings() {
        tableView.rx.modelSelected(PlayerViewModel.self)
            .bind(to: viewModel.playerViewModelSelectedPublishRelay)
            .disposed(by: disposeBag)

        backBarButton.rx.tap
            .bind(to: rx.popFromNavigationController)
            .disposed(by: disposeBag)

        viewModel.playViewModelsObservable.bind(to: tableView.rx.items(cellIdentifier: "InvitePlayersTableViewCell", cellType: InvitePlayersTableViewCell.self))(viewModel.cellConfiguration).disposed(by: disposeBag)

        viewModel.currentUserImageDriver
            .drive(currentUserPlayerImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.selectedPlayerViewModelsDriver
            .drive(rx.selectedPlayers)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: InvitePlayersViewController {
    var selectedPlayers: Binder<[PlayerViewModel]> {
        return Binder(self.base) { viewController, viewModels in
            viewModels.enumerated().forEach {
                $0.element.playerSharedImageDriver
                    .drive(viewController.playersImageViews[$0.offset].rx.image)
                    .disposed(by: $0.element.disposeBag)
            }

            for i in viewModels.count..<viewController.playersImageViews.count {
                viewController.playersImageViews[i].image = i < 2 ? UIImage(named: "friend") ?? UIImage() : UIImage(named: "friend-1") ?? UIImage()
            }
        }
    }
}
