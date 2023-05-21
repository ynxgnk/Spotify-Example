//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 02.05.2023.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    var albums = [Album]() /* 1986 copy whole file from LibraryPlaylistsViewController and change */
   
    private let noAlbumsView = ActionLabelView() /* 1986 */
    
    private let tableView: UITableView = { /* 1986 */
        let tableView = UITableView(frame: .zero, style: .grouped) /* 1986 */
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier) /* 1986 */
        tableView.isHidden = true /* 1986 */
        return tableView /* 1986 */
    }()
    
    private var observer: NSObjectProtocol? /* 2028 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 1635 ne menyay */
        tableView.delegate = self /* 1986 */
        tableView.dataSource = self /* 1986 */
        view.addSubview(tableView) /* 1986 */
        //        view.backgroundColor = .green /* 1995 */
        setUpNoAlbumsView() /* 1986 */
        fetchData() /* 1986 */
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in /* 2030 add weak self */
                self?.fetchData() /* 2031 */
            }
        ) /* 2029 */
    }
    
    @objc func didTapClose() { /* 1986 */
        dismiss(animated: true, completion: nil) /* 1986 */
    }
    
    override func viewDidLayoutSubviews() { /* 1986 */
        super.viewDidLayoutSubviews() /* 1986 */
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150) /* 1986 */
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height) /* 2017 */
    }
     
    private func setUpNoAlbumsView() { /* 1986 */
        view.addSubview(noAlbumsView) /* 1986 */
        noAlbumsView.delegate = self /* 1986 */
        noAlbumsView.configure(
            with: ActionLabelViewViewModel(
            text: "You have not saved any albums yet.",
            actionTitle: "Browse"
            )
        ) /* 1986 */
    }
    
    private func fetchData() { /* 1986 */
        albums.removeAll() /* 2032 */
        APICaller.shared.getCurrentUserAlbums { [weak self] result in /* 1986 */
            DispatchQueue.main.async { /* 1986 */
                switch result { /* 1986 */
                case .success(let albums): /* 1986 */
//                    print("albums: \(albums)") /* 2018 */
                    self?.albums = albums /* 1986 */
                    self?.updateUI() /* 1986 */
                case .failure(let error): /* 1986 */
                    print(error.localizedDescription) /* 1986 */
                }
            }
        }
    }
    
    private func updateUI() { /* 1986 */
        if albums.isEmpty { /* 1986 */
            //Show label
//            noAlbumsView.backgroundColor = .red /* 1994 */
            noAlbumsView.isHidden = false /* 1986 */
            tableView.isHidden = true /* 1986 */
        }
        else { /* 1986 */
            //Show table
            tableView.reloadData() /* 1986 */
            noAlbumsView.isHidden = true /* 1986 */
            tableView.isHidden = false /* 1986 */
        }
    }
}


extension LibraryAlbumsViewController: ActionLabelViewDelegate { /* 1986 */
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) { /* 1986 */
        //Show creation UI
        tabBarController?.selectedIndex = 0 /* 1987 */
    }
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource { /* 1986 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 1986 */
        return albums.count /* 1986 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 1986 */
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else { /* 1986 */
            return UITableViewCell() /* 1986 */
        }
        let album = albums[indexPath.row] /* 1986 */
        cell.configure(
            with: SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "-",
                imageURL: URL(string: album.images.first?.url ?? "")
            )
        ) /* 1986 */
        return cell /* 1986 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 1986 */
        tableView.deselectRow(at: indexPath, animated: true) /* 1986 */
        HapticsManager.shared.vibrateForSelection() /* 2050 */
        let album = albums[indexPath.row] /* 1986 */
        let vc = AlbumViewController(album: album) /* 1986 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1986 */
        navigationController?.pushViewController(vc, animated: true) /* 1986 */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { /* 1986 */
        return 70 /* 1986 */
    }
}
