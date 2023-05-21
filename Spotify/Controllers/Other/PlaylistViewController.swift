//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private let playlist: Playlist /* 738 */
    
    public var isOwner = false /* 1958 */
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            ) /* 803 copy from case 2 and change */
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2) /* 803 */
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitem: item,
                count: 1
            ) /* 527 */
            
            //Section
            let section = NSCollectionLayoutSection(group: group) /* 803 */
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem( /* 834 */
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(1)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ] /* 833 */
            return section /* 803 */
            
        }) /* 802 */
    )
    
    init(playlist: Playlist) { /* 739 */
        self.playlist = playlist /* 740 */
        super.init(nibName: nil, bundle: nil) /* 741 */
    }
    
    required init?(coder: NSCoder) { /* 742 */
        fatalError() /* 743 */
    }
    
    private var viewModels = [RecommendedTrackCellViewModel]() /* 825 */
    private var tracks = [AudioTrack]() /* 1389 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name /* 744 */
        view.backgroundColor = .systemBackground /* 745 */
        view.addSubview(collectionView) /* 804 */
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                 forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier
        ) /* 808 */
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier
        ) /* 844 */
        collectionView.backgroundColor = .systemBackground /* 805 */
        collectionView.dataSource = self /* 806 */
        collectionView.delegate = self /* 807 */
        
        APICaller.shared.getPlaylistDetails(for: playlist) { [weak self] result in /* 785  */ /* 827 add weak self */
            DispatchQueue.main.async { /* 826 */
                switch result { /* 786 */
                case .success(let model): /* 787 */
                    //RecommendedTrackcellViewModel
                    self?.tracks = model.tracks.items.compactMap({ $0.track }) /* 1390 means: that self?.tracks is an array of the actual tracks that are owned by this playlist */
                    self?.viewModels = model.tracks.items.compactMap({ /* 829  */
                        RecommendedTrackCellViewModel(
                            name: $0.track.name,
                            artistName: $0.track.artists.first?.name ?? "-",
                            artworkURL: URL(string: $0.track.album?.images.first?.url ?? "")
                        ) /* 830 */
                    })
                    self?.collectionView.reloadData() /* 828 */
                case .failure(let error): /* 787 */
                    print(error)
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        ) /* 914 */
        
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(didLongPress(_:))) /* 1960 */
        
        collectionView.addGestureRecognizer(gesture) /* 1961 */
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) { /* 1962 */
        guard gesture.state == .began else { /* 1963 */
            return /* 1964 */
        }
        let touchPoint = gesture.location(in: collectionView) /* 1965 */
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { /* 1966 */
            return /* 1967 */
        }
        let trackToDelete = tracks[indexPath.row] /* 1968 */
        
        let actionSheet = UIAlertController(
            title: trackToDelete.name,
            message: "Would you like to remove this from the playlist?",
            preferredStyle: .actionSheet
        ) /* 1969 */
        actionSheet.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil)
        ) /* 1970 */
        actionSheet.addAction(
            UIAlertAction(
                title: "Remove",
                style: .destructive,
                handler: { [weak self] _ in /* 1973 */ /* 1980 add weak self */
                    guard let strongSelf = self else { /* 1981 */
                        return /* 1982 */
                    }
                    APICaller.shared.removeTrackFromPlaylist(
                        track: trackToDelete,
                        playlist: strongSelf.playlist
                    ) { success in /* 1974 */
                        DispatchQueue.main.async { /* 1976 */
                            if success { /* 1975 */
                                print("Removed") /* 1983 */
                                strongSelf.tracks.remove(at: indexPath.row) /* 1977 */
                                strongSelf.viewModels.remove(at: indexPath.row) /* 1978 */
                                strongSelf.collectionView.reloadData() /* 1979 */
                            }
                            else { /* 1984 */
                                print("Failed to remove") /* 1985 */
                            }
                        }
                    }
                }
            )
        ) /* 1971 */
        present(actionSheet, animated: true) /* 1972 */
    }
    
    @objc private func didTapShare() { /* 915 */
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else { /* 920 */
            return /* 921 */
        }
        
        print(playlist.external_urls) /* 919 */
        let vc = UIActivityViewController(
            activityItems: [url], /* 922 add url */
            applicationActivities: []
        ) /* 916 */
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem /* 917 */
        present(vc, animated: true) /* 918 */
    }
    
    override func viewDidLayoutSubviews() { /* 820 */
        super.viewDidLayoutSubviews() /* 821 */
        collectionView.frame = view.bounds /* 822 */
    }
}


extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource { /* 809 */
    func numberOfSections(in collectionView: UICollectionView) -> Int { /* 810 */
        return 1 /* 811 */
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 812 */
        return viewModels.count /* 813 */ /* 831 change 30 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 814 */
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
            for: indexPath
        ) as? RecommendedTrackCollectionViewCell else { /* 815 */ /* 817 add as? */
            return UICollectionViewCell() /* 819 */
        }
        //       cell.backgroundColor = .red /* 816 */
        cell.configure(with: viewModels[indexPath.row]) /* 832 */
        return cell /* 818 */
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView { /* 845 */
        guard let header = collectionView.dequeueReusableSupplementaryView( /* 848 */
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? PlaylistHeaderCollectionReusableView, /* 849 add as? */
              kind == UICollectionView.elementKindSectionHeader else { /* 846 */
            return UICollectionReusableView() /* 847 */
        }
        let headerViewModel = PlaylistHeaderViewViewModel(
            name: playlist.name,
            ownerName: playlist.owner.display_name,
            description: playlist.description,
            artworkURL: URL(string: playlist.images.first?.url ?? "")
        ) /* 882 */
        header.configure(with: headerViewModel) /* 883 */
        header.delegate = self /* 910 */
        return header /* 850 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 823 */
        collectionView.deselectItem(at: indexPath, animated: true) /* 824 */
        //Play song
        let index = indexPath.row /* 1388 */
        let track = tracks[index] /* 1391 */
        PlaybackPresenter.shared.startPlayback(from: self, track: track) /* 1392 */
    }
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate { /* 911 */
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) { /* 912 */
        //Start play list play in queue
        PlaybackPresenter.shared.startPlayback(
            from: self,
            tracks: tracks
        ) /* 1393 */
        //        print("Playing all") /* 913 */
    }
}
