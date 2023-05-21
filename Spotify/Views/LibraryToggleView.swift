//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 02.05.2023.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject { /* 1688 */
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) /* 1689 */
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) /* 1690 */

}

class LibraryToggleView: UIView {
    
    enum State { /* 1708 */
        case playlist /* 1709 */
        case album /* 1709 */
    }
    
    var state: State = .playlist /* 1710 */
    
    weak var delegate: LibraryToggleViewDelegate? /* 1691 */

    private let playlistButton: UIButton = { /* 1667 */
       let button = UIButton() /* 1668 */
        button.setTitleColor(.label, for: .normal) /* 1669 */
        button.setTitle("Playlists", for: .normal) /* 1670 */
        return button /* 1671 */
    }()
    
    private let albumsButton: UIButton = { /* 1672 */
       let button = UIButton() /* 1673 */
        button.setTitleColor(.label, for: .normal) /* 1674 */
        button.setTitle("Albums", for: .normal) /* 1675 */
        return button /* 1676 */
    }()
    
    private let indicatorView: UIView = { /* 1700 */
        let view = UIView() /* 1701 */
        view.backgroundColor = .systemGreen /* 1702 */
        view.layer.masksToBounds = true /* 1704 */
        view.layer.cornerRadius = 4 /* 1705 */
        return view /* 1703 */
    }()
    
    override init(frame: CGRect) { /* 1660 */
        super.init(frame: frame) /* 1661 */
//        backgroundColor = .red /* 1662 */
        addSubview(playlistButton) /* 1677 */
        addSubview(albumsButton) /* 1678 */
        addSubview(indicatorView) /* 1706 */
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside) /* 1679 */
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside) /* 1681 */
    }
    
    required init?(coder: NSCoder) { /* 1663 */
        fatalError() /* 1664 */
    }
    
    @objc private func didTapPlaylists() { /* 1680 */
        state = .playlist /* 1711 */
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator() /* 1717 */
        }
        delegate?.libraryToggleViewDidTapPlaylists(self) /* 1692 */
    }
    
    @objc private func didTapAlbums() { /* 1682 */
        state = .album /* 1712 */
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator() /* 1716 */
        }
        delegate?.libraryToggleViewDidTapAlbums(self) /* 1693 */
    }
    
    override func layoutSubviews() { /* 1665 */
        super.layoutSubviews() /* 1666 */
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40) /* 1683 */
        albumsButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40) /* 1684 */
        layoutIndicator()
    }
    
    func layoutIndicator() { /* 1715 */
        switch state { /* 1713 */
        case .playlist: /* 1714 */
            indicatorView.frame = CGRect(
                x: 0,
                y: playlistButton.bottom,
                width: 100,
                height: 3
            ) /* 1707 */
        case .album: /* 1714 */
            indicatorView.frame = CGRect(
                x: 100,
                y: playlistButton.bottom,
                width: 100,
                height: 3
            ) /* 1707 */
        }
    }
    
    func update(for state: State) { /* 1718 */
        self.state = state /* 1719 */
        UIView.animate(withDuration: 0.2) { /* 1720 */
            self.layoutIndicator() /* 1721 */
        }
    }
}
