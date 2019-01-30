//
//  GameViewEndGameViewController.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/30/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewEndGameViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var taleTitleLabel: UILabel!
    @IBOutlet var playerImageViews: [UIImageView]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var taleParagraphsLabel: UILabel!
    @IBOutlet weak var theEndLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!

    private let disposeBag = DisposeBag()
    var viewModel: GameViewEndGameViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.cream
        scrollView.backgroundColor = UIColor.cream
        scrollViewContentView.backgroundColor = UIColor.cream
    }

    private func setupBindings() {
        guard let viewModel = viewModel else { return }

        viewModel.taleColorDriver
            .drive(selectedColorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.taleTitleTextDriver
            .drive(taleTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.playerImagesDriver
            .drive(rx.playerImages)
            .disposed(by: disposeBag)

        viewModel.taleParagraphsDriver
            .drive(rx.paragraphs)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: GameViewEndGameViewController {
    fileprivate var playerImages: Binder<[UIImage]> {
        return Binder(self.base) { viewController, images in
            images.enumerated().forEach {
                viewController.playerImageViews[$0.offset].image = $0.element
            }
        }
    }

    fileprivate var paragraphs: Binder<[TaleFirestoreParagraph]> {
        return Binder<[TaleFirestoreParagraph]>(self.base) { viewController, paragraphs in
            var text = ""

            paragraphs.forEach {
                text += $0.paragraphText + " "
            }

            viewController.taleParagraphsLabel.text = text
        }
    }
}
