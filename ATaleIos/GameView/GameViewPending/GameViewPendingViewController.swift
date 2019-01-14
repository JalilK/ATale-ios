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
import Action

class GameViewPendingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.cream

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName: "GameViewPendingSectionHeaderCell", bundle: nil), forCellReuseIdentifier: "GameViewPendingSectionHeaderCell")
        tableView.register(UINib(nibName: "InvitePlayersTableViewCell", bundle: nil), forCellReuseIdentifier: "InvitePlayersTableViewCell")
        tableView.backgroundColor = UIColor.cream

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
        guard let viewModel = viewModel else { return }

        acceptButton.rx
            .tap
            .bind(to: viewModel.acceptButtonTappedPublishRelay)
            .disposed(by: disposeBag)

        declineButton.rx
            .tap
            .bind(to: viewModel.declineButtonTappedPublishRelay)
            .disposed(by: disposeBag)

        viewModel.selectedColorDriver
            .drive(selectedColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.taleTitleDriver
            .drive(taleTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.taleCreatorImageDriver
            .drive(creatorImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.taleInviteTextDriver
            .drive(creatorInviteLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.acceptAlertSignal
            .emit(to: rx.showAcceptAlertController)
            .disposed(by: disposeBag)

        viewModel.declineAlertSignal
            .emit(to: rx.showDeclineAlertController)
            .disposed(by: disposeBag)

        viewModel.declineAlertSignal
            .emit(to: rx.showUpdateErrorAlertController)
            .disposed(by: disposeBag)

        viewModel.completionSignal
            .filter { $0 }
            .map { _ in () }
            .emit(to: rx.goToHomeViewController)
            .disposed(by: disposeBag)

        viewModel.tableViewDatasourceObservable
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
    }
}

extension GameViewPendingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let headerView = tableView.dequeueReusableCell(withIdentifier: "GameViewPendingSectionHeaderCell") as? GameViewPendingSectionHeaderCell,
            let viewModel = viewModel,
            viewModel.dataSource.sectionModels.count > 0
            else { return UIView() }

        let view = UIView()
        view.addSubview(headerView)

        headerView.titleLabel.text = viewModel.dataSource.sectionModels[section].header

        return view
    }
}

extension Reactive where Base: GameViewPendingViewController {
    var showAcceptAlertController: Binder<Void> {
        return Binder(self.base) { gameViewPendingViewController, _ in
            guard let viewModel = gameViewPendingViewController.viewModel else { return }

            let alert = UIAlertController(title: "Accept Invitation", message: "Are you sure you want to accept this invitation?", preferredStyle: .actionSheet)
            var yesAction = UIAlertAction(title: "Yes", style: .default, handler: { $0.rx.action?.execute(()) })
            yesAction.rx.action = viewModel.acceptInviteAlertYesButtonAction
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

            alert.addAction(yesAction)
            alert.addAction(noAction)

            gameViewPendingViewController.present(alert, animated: true, completion: nil)
        }
    }

    var showDeclineAlertController: Binder<Void> {
        return Binder(self.base) { gameViewPendingViewController, _ in
            guard let viewModel = gameViewPendingViewController.viewModel else { return }

            let alert = UIAlertController(title: "Decline Invitation", message: "Are you sure you want to decline this invitation?", preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

            alert.addAction(yesAction)
            alert.addAction(noAction)

            gameViewPendingViewController.present(alert, animated: true, completion: nil)
        }
    }

    var showUpdateErrorAlertController: Binder<Void> {
        return Binder(self.base) { gameViewPendingViewController, _ in
            guard let viewModel = gameViewPendingViewController.viewModel else { return }

            let alert = UIAlertController(title: "Something went wrong.", message: "Please check your internet connection and try again.", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)

            gameViewPendingViewController.present(alert, animated: true, completion: nil)
        }
    }
}
