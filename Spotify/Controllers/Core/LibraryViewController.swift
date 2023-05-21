//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

class LibraryViewController: UIViewController {

    private let playlistsVC = LibraryPlaylistsViewController() /* 1636 */
    private let albumsVC = LibraryAlbumsViewController() /* 1637 */
    
    private let scrollView: UIScrollView = { /* 1638 */
        let scrollView = UIScrollView() /* 1639 */
        scrollView.isPagingEnabled = true /* 1640 */
        
        return scrollView /* 1641 */
    }()
    
    private let toggleView = LibraryToggleView() /* 1685 */
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 26 */
        
        view.addSubview(toggleView) /* 1686 */
        toggleView.delegate = self /* 1694 */
        
        scrollView.delegate = self /* 1646 */
        view.addSubview(scrollView) /* 1642 */
//        scrollView.backgroundColor = .yellow /* 1648 */
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height) /* 1655 */
        
        addChildren() /* 1650 */
        updateBarButtons() /* 1850 */
    }
    
    override func viewDidLayoutSubviews() { /* 1643 */
        super.viewDidLayoutSubviews() /* 1644 */
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top+55,
            width: view.width,
            height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55
        ) /* 1645 */
        
        toggleView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: 200,
            height: 55
        ) /* 1687 */
    }
    
    private func updateBarButtons() { /* 1849 */
        switch toggleView.state { /* 1851 */
        case .playlist: /* 1852 */
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd)) /* 1853 */
        case .album: /* 1852 */
            navigationItem.rightBarButtonItem = nil /* 1854 */
        }
    }
    
    @objc private func didTapAdd() { /* 1856 */
        playlistsVC.showCreatePlaylistAlert() /* 1857 */
    }
    
    private func addChildren() { /* 1649 */
        addChild(playlistsVC) /* 1651 allows all view lifecycle functions to work appropriatly on the playlistsLibraryController */
        scrollView.addSubview(playlistsVC.view) /* 1652 */
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height) /* 1653 */
        playlistsVC.didMove(toParent: self) /* 1654 */
        
        addChild(albumsVC) /* 1656 */
        scrollView.addSubview(albumsVC.view) /* 1657 */
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height) /* 1658 */
        albumsVC.didMove(toParent: self) /* 1659 */
    }

}

extension LibraryViewController: UIScrollViewDelegate { /* 1646 */
    func scrollViewDidScroll(_ scrollView: UIScrollView) { /* 1647 */
//        print(scrollView.contentOffset.x) /* 1726 */
        if scrollView.contentOffset.x >= (view.width-100) { /* 1722 */
            toggleView.update(for: .album) /* 1723 */
            updateBarButtons() /* 1858 */
        }
        else { /* 1724 */
            toggleView.update(for: .playlist) /* 1725 */
            updateBarButtons() /* 1859 */
        }
    }
}

extension LibraryViewController: LibraryToggleViewDelegate { /* 1695 */
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) { /* 1697 */
        scrollView.setContentOffset(.zero, animated: true) /* 1698 */
        updateBarButtons() /* 1860 */
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) { /* 1696 */
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true) /* 1699 */
        updateBarButtons() /* 1861 */
    }
    
}
