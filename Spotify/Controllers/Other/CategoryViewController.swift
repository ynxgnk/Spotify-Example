//
//  CategoryViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import UIKit

class CategoryViewController: UIViewController {
    let category: Category /* 1133 */
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in /* 1150 */
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1))) /* 1151 */
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5) /* 1153 */
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(250)
           ),
            subitem: item,
            count: 2
        ) /* 1152 */
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5) /* 1154 */
        
        return NSCollectionLayoutSection(group: group) /* 1155 */
    }))
    
    //MARK: - Init
    
    init(category: Category) { /* 1134 */
        self.category = category /* 1135 */
        super.init(nibName: nil, bundle: nil) /* 1136 */
    }
    
    required init?(coder: NSCoder) { /* 1137 */
        fatalError() /* 1138 */
    }
    
    private var playlists = [Playlist]() /* 1146 */
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name /* 1139 */
        view.addSubview(collectionView) /* 1156 */
        view.backgroundColor = .systemBackground /* 1157 */
        collectionView.backgroundColor = .systemBackground /* 1158 */
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier
        ) /* 1161 */
        collectionView.delegate = self /* 1159 */
        collectionView.dataSource = self /* 1160 */
        
        APICaller.shared.getCategoryPlaylist(category: category) { [weak self] result in /* 1142 */ /* 1148 add weak self */
            DispatchQueue.main.async { /* 1149 */
                switch result { /* 1143 */
                case .success(let playlists): /* 1144 */
                    self?.playlists = playlists /* 1147 */
                    self?.collectionView.reloadData() /* 1172 */
                case .failure(let error): /* 1144 */
                    print(error.localizedDescription) /* 1145 */
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() { /* 1140 */
        super.viewDidLayoutSubviews() /* 1141 */
        collectionView.frame = view.bounds /* 1171 */
    }
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate { /* 1162 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 1163 */
        return playlists.count /* 1164 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 1165 */
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                                                            for: indexPath
        ) as? FeaturedPlaylistCollectionViewCell else { /* 1166 */
            return UICollectionViewCell() /* 1167 */
        }
        let playlist = playlists[indexPath.row] /* 1170 */
        cell.configure(with: FeaturedPlaylistCellViewModel(
            name: playlist.name,
            artworkURL: URL(string: playlist.images.first?.url ?? ""),
            creatorName: playlist.owner.display_name)
        ) /* 1169 */
        return cell /* 1168 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 1179 */
        collectionView.deselectItem(at: indexPath, animated: true) /* 1180 */
        let vc = PlaylistViewController(playlist: playlists[indexPath.row]) /* 1181 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1183 */
        navigationController?.pushViewController(vc, animated: true) /* 1182 */
    }
}
