//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit
import SDWebImage /* 1510 */

protocol PlayerViewControllerDelegate: AnyObject { /* 1548 */
    func didTapPlayPause() /* 1549 */
    func didTapForward() /* 1550 */
    func didTapBackward() /* 1551 */
    func didSlideSlider(_ value: Float) /* 1585 */
}

class PlayerViewController: UIViewController {

    weak var dataSource: PlayerDataSource? /* 1507 */
    weak var delegate: PlayerViewControllerDelegate? /* 1552 */
    
    private let imageView: UIImageView = { /* 1404 */
       let imageView = UIImageView() /* 1405 */
        imageView.contentMode = .scaleAspectFill /* 1406 */
//        imageView.backgroundColor = .systemBlue /* 1407 */
        return imageView /* 1408 */
    }()
    
    private let controlsView = PlayerControlsView() /* 1430 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 1383 */
        view.addSubview(imageView) /* 1409 */
        view.addSubview(controlsView) /* 1431 */
        controlsView.delegate = self /* 1497 */
        configureBarButtons() /* 1415 */
        configure() /* 1509 */
    }
    override func viewDidLayoutSubviews() { /* 1402 */
        super.viewDidLayoutSubviews() /* 1403 */
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width) /* 1410 */
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom+10,
            width: view.width-20,
            height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15
        ) /* 1432 */
    }
    
    private func configure() { /* 1508 */
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil) /* 1511 */
        controlsView.configure(
            with: PlayerControlsViewViewModel(
                title: dataSource?.songName,
                subtitle: dataSource?.subtitle
            )
        ) /* 1538 */
    }
    
    private func configureBarButtons() { /* 1414 */
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        ) /* 1416 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction)
        ) /* 1417 */
    }
    
    @objc private func didTapClose() { /* 1418 */
        dismiss(animated: true, completion: nil) /* 1419 */
    }
    
    @objc private func didTapAction() { /* 1420 */
        //Actions
    }
    
    func refreshUI() { /* 1629 */
        
        configure() /* 1630 */
    }
}

extension PlayerViewController: PlayerControlsViewDelegate { /* 1498 */
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) { /* 1499 */
        delegate?.didTapPlayPause() /* 1553 */
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) { /* 1500 */
        delegate?.didTapForward() /* 1554 */
    }
    
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) { /* 1501 */
        delegate?.didTapBackward() /* 1555 */
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) { /* 1583 */
        delegate?.didSlideSlider(value) /* 1584 */
    }
}
