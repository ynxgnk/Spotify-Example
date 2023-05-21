//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 30.04.2023.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let collectionView = UICollectionView( /* 962 copy from PlaylistViewController and change */
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            ) /* 962 */
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2) /* 962 */
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitem: item,
                count: 1
            ) /* 962 */
            
            //Section
            let section = NSCollectionLayoutSection(group: group) /* 962 */
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem( /* 962 */
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(1)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ] /* 962 */
            return section /* 962 */
        }) /* 962 */
    )
    
    private var viewModels = [AlbumCollectionViewCellViewModel]() /* 962 */ /* 975 change RecommendedTrackCellViewModel */
    
    private var tracks = [AudioTrack]() /* 1394 */
    
    private let album: Album /* 729 */
    
    init(album: Album) { /* 727 */
        self.album = album /* 728 */
        super.init(nibName: nil, bundle: nil) /* 730 */
    }
    
    required init?(coder: NSCoder) { /* 731 */
        fatalError() /* 732 */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name /* 725 */ /* 737 change "Album" */
        view.backgroundColor = .systemBackground /* 726 */
        
        view.addSubview(collectionView) /* 961 copy from 804 */
        collectionView.register(AlbumTrackCollectionViewCell.self /* 969 change RecommendedTrackCollectionView */
                                , forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier /* 970 cgane AlbumTrackCollectionViewCell */
        ) /* 961 */
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier
        ) /* 961 */
        collectionView.backgroundColor = .systemBackground /* 961 */
        collectionView.dataSource = self /* 961 */
        collectionView.delegate = self /* 961 */
        fetchData() /* 1997 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapActions)) /* 1998 */
    }
    
    @objc func didTapActions() { /* 1999 */
        let actionSheet = UIAlertController(title: album.name,
                                            message: "Actions",
                                            preferredStyle: .actionSheet) /* 2000 */
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) /* 2002 */
        actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { [weak self] _ in /* 2003 */ /* 2013 add weak self */
            guard let strongSelf = self else { /* 2014 */
                return /* 2015 */
            }
            APICaller.shared.saveAlbum(album: strongSelf.album) { success in /* 2012 */
//                print("Saved \(success)") /* 2016 */
                if success { /* 2026 */
                    HapticsManager.shared.vibrate(for: .success) /* 2053 */
                    NotificationCenter.default.post(name: .albumSavedNotification, object: nil) /* 2027 */
                }
                else { /* 2054 */
                    HapticsManager.shared.vibrate(for: .error) /* 2055 */
                }
            }
        }))
        present(actionSheet,animated: true) /* 2001 */
    }
    
    func fetchData() { /* 1996 */
        APICaller.shared.getAlbumDetails(for: album) { [weak self] result in /* 764 */ /* 964 add weak self */
            DispatchQueue.main.async { /* 765 */
                switch result { /* 766 */
                case .success(let model): /* 767 */
                    self?.tracks = model.tracks.items /* 1395 */
                    self?.viewModels = model.tracks.items.compactMap({ /* 963 copy from 829 and change */
                        AlbumCollectionViewCellViewModel( /* 976 change RecommendedTrackCellViewModel */
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-"
                        ) /* 963 */
                    })
                    self?.collectionView.reloadData() /* 963 */
                case .failure(let error): /* 767 */
                    print(error.localizedDescription) /* 965 */
                }
            }
        }
    }
        
        override func viewDidLayoutSubviews() { /* 966 copy from PlaylistViewController(915) and change  */
            super.viewDidLayoutSubviews() /* 966 */
            collectionView.frame = view.bounds /* 966 */
        }
    }


    extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource { /* 966 */
        func numberOfSections(in collectionView: UICollectionView) -> Int { /* 966 */
            return 1 /* 966 */
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 966 */
            return viewModels.count /* 966 */
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 966 */
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, /* 972 change RecommendedTrackCollectionViewCell */
                for: indexPath
            ) as? AlbumTrackCollectionViewCell else { /* 966 */ /* 971 change RecommendedTrackCollectionViewCell  */
                return UICollectionViewCell() /* 966 */
            }
            cell.configure(with: viewModels[indexPath.row]) /* 966 */
            return cell /* 966 */
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView { /* 966 */
            guard let header = collectionView.dequeueReusableSupplementaryView( /* 966 */
                ofKind: kind,
                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                for: indexPath
            ) as? PlaylistHeaderCollectionReusableView, /* 966 */
                  kind == UICollectionView.elementKindSectionHeader else { /* 966 */
                return UICollectionReusableView() /* 966 */
            }
            let headerViewModel = PlaylistHeaderViewViewModel(
                name: album.name,
                ownerName: album.artists.first?.name,
                description: "Release Date: \(String.formattedDate(string: album.release_date))", /* 991 change \(album.release_date) */
                artworkURL: URL(string: album.images.first?.url ?? "")
            ) /* 966 */
            header.configure(with: headerViewModel) /* 966 */
            header.delegate = self /* 966 */
            return header /* 966 */
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 966 */
            collectionView.deselectItem(at: indexPath, animated: true) /* 966 */
            //Play song
            var track = tracks[indexPath.row] /* 1396 */ /* 1624 change to var */
            track.album = self.album /* 1625 */
            PlaybackPresenter.shared.startPlayback(from: self, track: track) /* 1397 */
        }
    }

    extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate { /* 966 */
        func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) { /* 966 */
            //Start play list play in queue
//            print("Playing all") /* 966 */
            var tracksWithAlbum: [AudioTrack] = tracks.compactMap({ /* 1619 */
                var track = $0 /* 1620 */
                track.album = self.album /* 1621 */
                return track /* 1622 */
            })
            PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum) /* 1398 */ /* 1623 change tracks */
        }
    }

