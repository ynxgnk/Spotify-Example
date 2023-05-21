//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 02.05.2023.
//

import Foundation
import UIKit /* 1421 */

protocol PlayerControlsViewDelegate: AnyObject { /* 1483 */
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) /* 1484 */
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) /* 1485 */
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) /* 1486 */
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) /* 1578 */

}

struct PlayerControlsViewViewModel { /* 1532 */
    let title: String? /* 1533 */
    let subtitle: String? /* 1534 */
}

final class PlayerControlsView: UIView { /* 1422 */
    
    private var isPlaying = true /* 1573 */
    
    weak var delegate: PlayerControlsViewDelegate? /* 1487 */
    
    private let volumeSlider: UISlider = { /* 1433 */
       let slider = UISlider() /* 1434 */
        slider.value = 0.5 /* 1435 */
        return slider /* 1436 */
    }()
    
    private let nameLabel: UILabel = { /* 1437 */
        let label = UILabel() /* 1438 */
        label.text = "This is My Song" /* 1481 */
        label.numberOfLines = 1 /* 1439 */
        label.font = .systemFont(ofSize: 20, weight: .semibold) /* 1440 */
        return label /* 1441 */
    }()
    
    private let subtitleLabel: UILabel = { /* 1442 */
        let label = UILabel() /* 1443 */
        label.text = "Drake (feat. Some Other Artist)" /* 1482 */
        label.numberOfLines = 1 /* 1444 */
        label.font = .systemFont(ofSize: 18, weight: .regular) /* 1445 */
        label.textColor = .secondaryLabel /* 1446 */
        return label /* 1447 */
    }()
    
    private let backButton: UIButton = { /* 1448 */
       let button = UIButton() /* 1449 */
        button.tintColor = .label /* 1450 */
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)) /* 1452 */
        button.setImage(image, for: .normal) /* 1453 */
        return button /* 1451 */
    }()
    
    private let nextButton: UIButton = { /* 1455 */
       let button = UIButton() /* 1456 */
        button.tintColor = .label /* 1457 */
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)) /* 1458 */
        button.setImage(image, for: .normal) /* 1459 */
        return button /* 1460 */
    }()
    
    private let playPauseButton: UIButton = { /* 1461 */
       let button = UIButton() /* 1462 */
        button.tintColor = .label /* 1463 */
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)) /* 1464 */
        button.setImage(image, for: .normal) /* 1465 */
        return button /* 1466 */
    }()
    
    override init(frame: CGRect) { /* 1423 */
        super.init(frame: frame) /* 1424 */
        backgroundColor = .clear /* 1425 */
        addSubview(nameLabel) /* 1467 */
        addSubview(subtitleLabel) /* 1468 */
        
        addSubview(volumeSlider) /* 1469 */
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged) /* 1579 */
        
        addSubview(backButton) /* 1470 */
        addSubview(nextButton) /* 1471 */
        addSubview(playPauseButton) /* 1472 */
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside) /* 1488 */
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside) /* 1489 */
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside) /* 1490 */
        
        clipsToBounds = true /* 1473 */
    }
    
    required init?(coder: NSCoder) { /* 1426 */
        fatalError() /* 1427 */
    }
    
    @objc func didSlideSlider(_ slider: UISlider) { /* 1580 */
        let value = slider.value /* 1581 */
        delegate?.playerControlsView(self, didSlideSlider: value) /* 1582 */
    }
    
    @objc private func didTapBack() { /* 1491 */
        delegate?.playerControlsViewDidTapBackwardsButton(self) /* 1494 */
    }
    
    @objc private func didTapNext() { /* 1492 */
        delegate?.playerControlsViewDidTapForwardButton(self) /* 1495 */ 
    }
    
    @objc private func didTapPlayPause() { /* 1493 */
        self.isPlaying = !isPlaying /* 1574 */
        delegate?.playerControlsViewDidTapPlayPauseButton(self) /* 1496 */
        
        //Update icon
        let pause = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)) /* 1576 */
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)) /* 1577 */
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal) /* 1575 */
    }
    
    override func layoutSubviews() { /* 1428 */
        super.layoutSubviews() /* 1429 */
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50) /* 1474 */
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50) /* 1475 */
        
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom+20, width: width-20, height: 44) /* 1476 */
        
        let buttonSize: CGFloat = 60 /* 1477 */
        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize) /* 1478 */
        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize) /* 1479 */
        nextButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize) /* 1480 */
    }
    
    func configure(with viewModel: PlayerControlsViewViewModel) { /* 1535 */
        nameLabel.text = viewModel.title /* 1536 */
        subtitleLabel.text = viewModel.subtitle /* 1537 */
    }
}
