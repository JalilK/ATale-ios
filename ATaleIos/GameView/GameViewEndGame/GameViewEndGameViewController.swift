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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        playerImageViews.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.layer.masksToBounds = false
            $0.clipsToBounds = true
        }
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

        viewModel.playerColorsDriver
            .drive(rx.playerColors)
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

    fileprivate var playerColors: Binder<[UIColor]> {
        return Binder(self.base) { viewController, colors in
            colors.enumerated().forEach {
                viewController.playerImageViews[$0.offset].layer.borderWidth = 5
                viewController.playerImageViews[$0.offset].layer.borderColor = $0.element.cgColor
            }
        }
    }

    fileprivate var paragraphs: Binder<[(TaleFirestoreParagraph, UIColor)]> {
        return Binder(self.base) { viewController, paragraphWithColorTuples in
            var text = ""

            paragraphWithColorTuples.forEach { text += $0.0.paragraphText + " " }

            let attributedString = NSMutableAttributedString(string: text)

            paragraphWithColorTuples.forEach {
                let range = (text as NSString).range(of: $0.0.paragraphText)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: $0.1, range: range)
            }

            viewController.taleParagraphsLabel.attributedText = attributedString
        }
    }
}
