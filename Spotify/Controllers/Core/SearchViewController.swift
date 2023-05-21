//
//  SearchViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit
import SafariServices /* 1375 */

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate { /* 1002 add 1 protocol */ /* 1205 add 1 protocol */

    let searchController: UISearchController = { /* 992 */
//        let results = UIViewController() /* 993 */
//        results.view?.backgroundColor = .red /* 994 */
        let vc = UISearchController(searchResultsController: SearchResultsViewController()) /* 995 */ /* 1008 change results */
        vc.searchBar.placeholder = "Songs, Artists, Albums" /* 996 */
        vc.searchBar.searchBarStyle = .minimal /* 997 */
        vc.definesPresentationContext = true /* 999 */
        return vc /* 998 */
    }()
    
    private let collectionView: UICollectionView = UICollectionView( /* 1010 */
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in /* 1011 */
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))) /* 1012 */
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 7,
                bottom: 2,
                trailing: 7
            ) /* 1032 */
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(150)),
                subitem: item,
                count: 2
            ) /* 1013 */
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 0,
                bottom: 10,
                trailing: 0
            ) /* 1033 */
            
            return NSCollectionLayoutSection(group: group) /* 1014 */
        })
    )
    
    private var categories = [Category]() /* 1118 */
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 25 */
        searchController.searchResultsUpdater = self /* 1001 */
        searchController.searchBar.delegate = self /* 1204 */
        navigationItem.searchController = searchController /* 1000 */
        view.addSubview(collectionView) /* 1015 */
        collectionView.register(CategoryCollectionViewCell.self, /* 1063 change UICollectionViewCell */
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier) /* 1019 */ /* 1064 change "cell" */
        collectionView.delegate = self /* 1016 */
        collectionView.dataSource = self /* 1017 */
        collectionView.backgroundColor = .systemBackground /* 1018 */
        
        APICaller.shared.getCategories { [weak self] result in /* 1087 */ /* 1090 add weak self */
            DispatchQueue.main.async { /* 1091 */
                switch result { /* 1088 */
                case .success(let categories): /* 1089 */
//                    let first = models.first! /* 1109 */
//                    APICaller.shared.getCategoryPlaylist(category: first) { FOO in /* 1110 */
//                    }
                    self?.categories = categories /* 1119 */
                    self?.collectionView.reloadData() /* 1120 */
                case .failure(let error): /* 1089 */
                    break
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() { /* 1029 */
        super.viewDidLayoutSubviews() /* 1030 */
        collectionView.frame = view.bounds /* 1031 */
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { /* 1206 */
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController, /* 1009 add resultsController */
              let query = searchBar.text, /* 1207 remove searchController. */
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { /* 1004 */
            return /* 1005 */
        }
        
        resultsController.delegate = self /* 1308 */
        
        APICaller.shared.search(with: query) { result in /* 1198 */
            DispatchQueue.main.async { /* 1199 */
                switch result { /* 1200 */
                case .success(let results): /* 1201 */
                    resultsController.update(with: results)
                case .failure(let error): /* 1201 */
                    print(error.localizedDescription) /* 1202 */
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) { /* 1003 */
        //resultsController.update(with: results
//        print(query) /* 1006 */
    }

}

extension SearchViewController: SearchResultsViewControllerDelegate { /* 1309 */
    func didTapResult(_ result: SearchResult) { /* 1310 */
        switch result { /* 1297 */
        case .artist(let model): /* 1298 */
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else { /* 1373 */
                return /* 1374 */
            }
            let vc = SFSafariViewController(url: url) /* 1376 */
            present(vc, animated: true) /* 1377 */
            
        case .album(let model): /* 1298 */
            let vc = AlbumViewController(album: model) /* 1299 */
            vc.navigationItem.largeTitleDisplayMode = .never /* 1301 */
            navigationController?.pushViewController(vc, animated: true) /* 1300 */
        case .track(let model): /* 1298 */
            PlaybackPresenter.shared.startPlayback(from: self, track: model) /* 1399 */
            break
        case .playlist(let model): /* 1298 */
            let vc = PlaylistViewController(playlist: model) /* 1303 */
            vc.navigationItem.largeTitleDisplayMode = .never /* 1302 */
            navigationController?.pushViewController(vc, animated: true) /* 1304 */
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource { /* 1020 */
    func numberOfSections(in collectionView: UICollectionView) -> Int { /* 1021 */
        return 1 /* 1024 */
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 1022 */
        return categories.count /* 1023 */ /* 1121 change 20 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 1025 */
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:  CategoryCollectionViewCell.identifier,
            for: indexPath
        ) as? CategoryCollectionViewCell else { /* 1026 */ /* 1065 add guard and change "cell" */ /* 1066 add as? */
            return UICollectionViewCell() /* 1067 */
        }
        let category = categories[indexPath.row] /* 1122 */
        cell.configure(
            with: CategoryCollectionViewCellViewModel(
                title: category.name,
                artworkURL: URL(string: category.icons.first?.url ?? "")
            )
        ) /* 1068 */ /* 1123 change "Rock" */ /* 1131 change category.name */
        //        cell.backgroundColor = .systemGreen /* 1027 */
        return cell /* 1028 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 1173 */
        collectionView.deselectItem(at: indexPath, animated: true) /* 1174 */
        HapticsManager.shared.vibrateForSelection() /* 2048 */
        let category = categories[indexPath.row] /* 1175 */
        let vc = CategoryViewController(category: category) /* 1176 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1177 */
        navigationController?.pushViewController(vc, animated: true) /* 1178 */
    }
}
