//
//  ViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

enum BrowseSectionType { /* 518 */
    case newReleases(viewModels: [NewReleasesCellViewModel]) /* 519 */ //1 /* 551 add viewModels */
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel]) /* 520 */ /* 558 add viewModels */ /* 687 change NewReleasesCellViewModel */
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel]) /* 521 */ //3 /* 559 add viewModels */ /* 688 change NewReleaseCollectionViewCell */
    
    var title: String { /* 955 */
        switch self { /* 956 */
        case .newReleases: /* 957 */
            return "New Released Albums" /* 958 */
        case .featuredPlaylists: /* 957 */
            return "Featured Playlists" /* 958 */
        case .recommendedTracks: /* 957 */
            return "Recommended" /* 958 */
        }
    }
}

class HomeViewController: UIViewController {

    private var newAlbums:[Album] = [] /* 713 */
    private var playlists: [Playlist] = [] /* 714 */
    private var tracks: [AudioTrack] = [] /* 715 */
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in /* 485 */
            return HomeViewController.createSectionLayout(section: sectionIndex) /* 484 */
        }
    ) /* 483 */
    
    private let spinner: UIActivityIndicatorView = { /* 509 */
       let spinner = UIActivityIndicatorView() /* 510 */
        spinner.tintColor = .label /* 511 */
        spinner.hidesWhenStopped = true /* 512 */
        return spinner /* 513 */
    }()
    
    private var sections = [BrowseSectionType]() /* 552 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse" /* 1 */
        view.backgroundColor = .systemBackground /* 2 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        ) /* 250 */
        configureCollectionView() /* 493 */
        view.addSubview(spinner) /* 514 */
        fetchData() /* 386 */
        addLongTapGesture() /* 1920 */
    }
    
    override func viewDidLayoutSubviews() { /* 506 */
        super.viewDidLayoutSubviews() /* 507 */
        collectionView.frame = view.bounds /* 508 */
    }
    
    private func addLongTapGesture() { /* 1919 */
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:))) /* 1921 */
        collectionView.isUserInteractionEnabled = true /* 1950 */
        collectionView.addGestureRecognizer(gesture) /* 1922 */
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) { /* 1923 */
        print("did hold")
        guard gesture.state == .began else { /* 1924 */
            return /* 1925 */
        }
        
        let touchPoint = gesture.location(in: collectionView) /* 1926 */
//        print("TouchPoint: \(touchPoint)") /* 1949 */
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
        indexPath.section == 2 else { /* 1927 */
            return /* 1928 */
        }
        
        let model = tracks[indexPath.row] /* 1929 */
        
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would you like to add this to a playlist?",
            preferredStyle: .actionSheet
        ) /* 1930 */
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) /* 1931 */
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: { [weak self] _ in /* 1932 */ /* 1936 add weak self */
            DispatchQueue.main.async { /* 1937 */
                let vc = LibraryPlaylistsViewController() /* 1933 */
                vc.selectionHandler = { playlist in /* 1939 */
                    APICaller.shared.addTrackToPlaylist(
                        track: model,
                        playlist: playlist
                    ) { success in /* 1951 */
//                        print("Added to playlist success: \(success)") /* 1952 */
                    }
                }
                vc.title = "Select Playlist" /* 1944 */
                self?.present(
                    UINavigationController(rootViewController: vc),
                    animated: true,
                    completion: nil
                ) /* 1934 */
            }
        }))
        present(actionSheet, animated: true) /* 1935 */
    }
    
    private func configureCollectionView() { /* 492 */
        view.addSubview(collectionView) /* 494 */
        collectionView.register(UICollectionViewCell.self,
                                 forCellWithReuseIdentifier: "cell") /* 495 */
        collectionView.register(NewReleaseCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier) /* 548 */
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier) /* 549 */
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier) /* 550 */
        collectionView.register(TitleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        ) /* 946 */
        collectionView.dataSource = self /* 496 */
        collectionView.delegate = self /* 497 */
        collectionView.backgroundColor = .systemBackground /* 498 */
    }
    
    private func fetchData() { /* 385 */
        let group =  DispatchGroup() /* 566 */
        group.enter() /* 567 */
        group.enter() /* 567 */
        group.enter() /* 567 */
        print("Start fetching data") /* 619 */
        
        var newReleases: NewReleasesResponse? /* 578 */
        var featuredPlaylist: FeaturedPlaylistsResponse? /* 582 */
        var recommendations: RecommendationsResponse? /* 586 */
        
        //New releases
        APICaller.shared.getNewReleases { result in /* 563 */
            defer { /* 568 */
                group.leave() /* 569 */
            }
            switch result { /* 564 */
            case .success(let model): /* 565 */
                newReleases = model /* 579 */
            case .failure(let error): /* 565 */
                print("HERE1! \(error.localizedDescription)") /* 580 */
            }
        }
        
        //Featured Playlists
        APICaller.shared.getFeaturedPlaylists { result in /* 560 */
            defer { /* 571 */
                group.leave() /* 572 */
            }
            switch result { /* 561 */
            case .success(let model): /* 562 */
                featuredPlaylist = model /* 583 */
            case .failure(let error): /* 562 */
                print("HERE2! \(error.localizedDescription)") /* 581 */
            }
        }
        
        //Recommended tracks
        APICaller.shared.getRecommendedGenres { result in /* 387 */ /* 417 change NewReleases to getFeaturedPlaylists */
            switch result { /* 388 */
            case .success(let model): /* 389 */
                let genres = model.genres /* 459 */
                var seeds = Set<String>() /* 460 */
                while seeds.count < 5 { /* 461 */
                    if let random = genres.randomElement() { /* 462 */
                        seeds.insert(random) /* 463 */
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in /* 464 */ /* 573 change _ */
                    defer { /* 576 */
                        group.leave() /* 577 */
                    }
                    switch recommendedResult { /* 574 */
                    case .success(let model): /* 575 */
                        recommendations = model /* 587 */
                    case .failure(let error): /* 575 */
                        print("HERE3! \(error.localizedDescription)") /* 584 */
                    }
                }
                
            case .failure(let error): /* 389 */
                print("HERE4! \(error.localizedDescription)") /* 389 */ /* 585 change break */
            }
        }
        
        group.notify(queue: .main) { /* 570 */
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else { /* 588 */
                fatalError("Models are nil") /* 620 */
                return /* 589 */
            }
            
            print("Configuring viewModels") /* 621 */
            self.configureModels(
                newAlbums: newAlbums,
                playlists: playlists,
                tracks: tracks
            ) /* 591 */
        }
    }
    
    private func configureModels(
        newAlbums: [Album],
        playlists: [Playlist],
        tracks: [AudioTrack]
    ) { /* 590 */
//        print(newAlbums.count) /* 623 */
//        print(playlists.count) /* 623 */
//        print(tracks.count) /* 623 */
        //Configure Models
        self.newAlbums = newAlbums /* 716 */
        self.playlists = playlists /* 717 */
        self.tracks = tracks /* 718 */
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({ /* 592 add newAlbums.compactMap */
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "-"
            ) /* 593 add compactMap */
        }))) /* 555 */
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({ /* 689 change [] */
            return FeaturedPlaylistCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name
            ) /* 690 */
        }))) /* 553 */
        
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTrackCellViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "-",
                artworkURL: URL(string: $0.album?.images.first?.url ?? "")
            ) /* 691 */
        }))) /* 554 */
        
        collectionView.reloadData() /* 622 */
    }
    
    @objc func didTapSettings() { /* 251 */
        let vc = SettingsViewController() /* 252 */
        vc.title = "Settings" /* 253 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 254 */
        navigationController?.pushViewController(vc, animated: true) /* 255 */
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource { /* 499 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 500 */
        let type = sections[section] /* 594 */
        switch type { /* 595 */
        case .newReleases(let viewModels): /* 596 */
            return viewModels.count /* 599 */
        case .featuredPlaylists(let viewModels): /* 597 */
            return viewModels.count /* 600 */
        case .recommendedTracks(let viewModels): /* 598 */
            return viewModels.count /* 601 */
        }
//        return 5 /* 501 */ /* 556 change 5 */
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { /* 530 */
        return sections.count /* 531 */ /* 557 change 3 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 502 */
        let type = sections[indexPath.section] /* 602 */
        switch type { /* 603 */
        case .newReleases(let viewModels): /* 604 */
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath
            ) as? NewReleaseCollectionViewCell else { /* 605 */ /* 607 add as? */
                return UICollectionViewCell() /* 608 */
            }
            let viewModel = viewModels[indexPath.row] /* 618 */
            cell.configure(with: viewModel) /* 672 */
//            cell.backgroundColor = .red /* 609 */
            return cell /* 606 */
        case .featuredPlaylists(let viewModels): /* 604 */
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath
            ) as? FeaturedPlaylistCollectionViewCell else { /* 610 */
                return UICollectionViewCell() /* 611 */
            }
//            cell.backgroundColor = .blue /* 612 */
            cell.configure(with: viewModels[indexPath.row]) /* 695 */
            return cell /* 613 */
        case .recommendedTracks(let viewModels): /* 604 */
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                for: indexPath
            ) as? RecommendedTrackCollectionViewCell else { /* 614 */
                return UICollectionViewCell() /* 615 */
            }
//            cell.backgroundColor = .orange /* 616 */
            cell.configure(with: viewModels[indexPath.row]) /* 707 */
            return cell /* 617 */
        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) /* 503 */
//        if indexPath.section == 0 { /* 532 */
//            cell.backgroundColor = .systemGreen /* 505 */
//        }
//        else if indexPath.section == 1 { /* 533 */
//            cell.backgroundColor = .systemPink /* 534 */
//        }
//        else if indexPath.section == 2 { /* 535 */
//            cell.backgroundColor = .systemBlue /* 536 */
//        }
//        return cell /* 504 */
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 719 */
        collectionView.deselectItem(at: indexPath, animated: true) /* 720 */
        HapticsManager.shared.vibrateForSelection() /* 2047 */
        let section = sections[indexPath.section] /* 721 */
        switch section { /* 722 */
        case .featuredPlaylists: /* 723 */
            let playlist = playlists[indexPath.row] /* 746 */
            let vc = PlaylistViewController(playlist: playlist) /* 747 */
            vc.title = playlist.name /* 748 */
            vc.navigationItem.largeTitleDisplayMode = .never /* 749 */
            navigationController?.pushViewController(vc, animated: true) /* 750 */
        case .newReleases: /* 723 */
            let album = newAlbums[indexPath.row] /* 724 */
            let vc = AlbumViewController(album: album) /* 733 */
            vc.title = album.name /* 734 */
            vc.navigationItem.largeTitleDisplayMode = .never /* 735 */
            navigationController?.pushViewController(vc, animated: true) /* 736 */
        case .recommendedTracks: /* 723 */
            let track = tracks[indexPath.row] /* 1386 */
            PlaybackPresenter.shared.startPlayback(from: self, track: track) /* 1387 */
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView { /* 947 */
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else { /* 948 */ /* 949 add as? */
            return UICollectionReusableView() /* 950 */
        }
        let section = indexPath.section /* 953 */
        let title = sections[section].title /* 954 */ /* 959 add title */
        header.configure(with: title) /* 952 */ /* 960 change "Home" */
        return header /* 951 */
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection { /* 486 */
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem( /* 923 */
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ] /* 923 copy from 833 and change */
        
        switch section { /* 522 */
        case 0: /* 523 */
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            ) /* 490 */
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2) /* 515 */
            
            //Vertical group in horzontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 3
            ) /* 489 */
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem: verticalGroup,
                count: 1
            ) /* 517 */
            
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup) /* 488 */
            section.orthogonalScrollingBehavior = .groupPaging /* 516 */
            section.boundarySupplementaryItems = supplementaryViews /* 924 */
            return section /* 491 */
            
        case 1: /* 524 */
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200), /* 539 change .fractionalWidth */
                    heightDimension: .absolute(200) /* 540 change .fractionalHeight */
                )
            ) /* 526 copy from 523 and change */
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2) /* 526 */
                    
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2
            ) /* 542 */
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200), /* 541 change .fractionalWidth */
                    heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1
            ) /* 526 */
            
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup) /* 526 */
            section.orthogonalScrollingBehavior = .continuous /* 526 */ /* 537 change .groupPaging */
            section.boundarySupplementaryItems = supplementaryViews /* 925 */
            return section /* 526 */
            
        case 2: /* 525 */
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            ) /* 527 copy from 526 and change */
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2) /* 527 */
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1
            ) /* 527 */
            
            //Section
            let section = NSCollectionLayoutSection(group: group) /* 527 */
            section.boundarySupplementaryItems = supplementaryViews /* 926 */
            return section /* 527 */
            
        default: /* 528 */
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            ) /* 529 copy from 527 and change */
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2) /* 529 */
            
            //Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            ) /* 529 */
            
            //Section
            let section = NSCollectionLayoutSection(group: group) /* 529 */
            section.boundarySupplementaryItems = supplementaryViews /* 927 */
            return section /* 529 */
        }
    }
    
}

