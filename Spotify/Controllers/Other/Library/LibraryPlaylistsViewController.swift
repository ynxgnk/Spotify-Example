//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 02.05.2023.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    var playlists = [Playlist]() /* 1756 */
    
    public var selectionHandler: ((Playlist) -> Void)? /* 1938 */
    
    private let noPlaylistsView = ActionLabelView() /* 1793 */
    
    private let tableView: UITableView = { /* 1868 */
        let tableView = UITableView(frame: .zero, style: .grouped) /* 1869 */
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier) /* 1870 */
        tableView.isHidden = true /* 1871 */
        return tableView /* 1872 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 1634 */
        tableView.delegate = self /* 1874 */
        tableView.dataSource = self /* 1875 */
        view.addSubview(tableView) /* 1873 */
        setUpNoPlaylistsView() /* 1805 */
        fetchData() /* 1807 */
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(didTapClose)
            ) /* 1946 */
        } /* 1945 */
    }
    
    @objc func didTapClose() { /* 1947 */
        dismiss(animated: true, completion: nil) /* 1948 */
    }
    
    override func viewDidLayoutSubviews() { /* 1796 */
        super.viewDidLayoutSubviews() /* 1797 */
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150) /* 1798 */
        noPlaylistsView.center = view.center /* 1799 */
        tableView.frame = view.bounds /* 1890 */
    }
     
    private func setUpNoPlaylistsView() { /* 1804 */
        view.addSubview(noPlaylistsView) /* 1802 */
        noPlaylistsView.delegate = self /* 1808 */
        noPlaylistsView.configure(with: ActionLabelViewViewModel(
            text: "You dont have any Playlists yet.",
            actionTitle: "Create"
            )
        ) /* 1795 */
    }
    
    private func fetchData() { /* 1806 */
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in /* 1745 */ /* 1754 add weak self */
            DispatchQueue.main.async { /* 1753 */
                switch result { /* 1746 */
                case .success(let playlists): /* 1747 */
                    self?.playlists = playlists /* 1755 */
                    self?.updateUI() /* 1758 */
                case .failure(let error): /* 1748 */
                    print(error.localizedDescription) /* 1749 */
                }
            }
        }
    }
    
    private func updateUI() { /* 1757 */
        if playlists.isEmpty { /* 1759 */
            //Show label
            noPlaylistsView.isHidden = false /* 1800 */
            tableView.isHidden = true /* 1889 */
        }
        else { /* 1760 */
            //Show table
            tableView.reloadData() /* 1886 */
            noPlaylistsView.isHidden = true /* 1888 */
            tableView.isHidden = false /* 1887 */
        }
    }
    
    public func showCreatePlaylistAlert() { /* 1855 */
        let alert = UIAlertController(
            title: "New Playlists",
            message: "Enter playlist name.",
            preferredStyle: .alert
        ) /* 1811 */
        alert.addTextField { textField in /* 1812 */
            textField.placeholder = "Playlist..." /* 1813 */
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) /* 1814 */
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in /* 1815 */
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else { /* 1816 */
                return /* 1817 */
            }
            
            APICaller.shared.createPlaylist(with: text) { [weak self] success in /* 1819 */ /* 1894 add weak self */
                if success { /* 1820 */
                    HapticsManager.shared.vibrate(for: .success) /* 2051 */
                    //Refresh list of playlists
                    self?.fetchData() /* 1895 */
                }
                else { /* 1821 */
                    HapticsManager.shared.vibrate(for: .error) /* 2052 */
                    print("Failed to create playlist") /* 1822 */
                }
            }
        }))
        present(alert, animated: true) /* 1818 */
    }
}


extension LibraryPlaylistsViewController: ActionLabelViewDelegate { /* 1809 */
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) { /* 1810 */
        //Show creation UI
        showCreatePlaylistAlert() /* 1856 */
    }
}

extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource { /* 1876 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 1877 */
        return playlists.count /* 1878 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 1879 */
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else { /* 1880 */ /* 1881 add as?*/
            return UITableViewCell() /* 1882 */
        }
        let playlist = playlists[indexPath.row] /* 1883 */
        cell.configure(
            with: SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? "")
            )
        ) /* 1884 */
        return cell /* 1885 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 1896 */
        tableView.deselectRow(at: indexPath, animated: true) /* 1897 */
        HapticsManager.shared.vibrateForSelection() /* 2049 */
        let playlist = playlists[indexPath.row] /* 1898 */
        guard selectionHandler == nil else { /* 1940 */
            selectionHandler?(playlist) /* 1942 */
            dismiss(animated: true, completion: nil) /* 1943 */
            return /* 1941 */
        }
        
        let vc = PlaylistViewController(playlist: playlist) /* 1899 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1900 */
        vc.isOwner = true /* 1959 */
        navigationController?.pushViewController(vc, animated: true) /* 1901 */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { /* 1892 */
        return 70 /* 1893 */
    }
}
