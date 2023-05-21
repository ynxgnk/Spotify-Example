//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

struct SearchSection { /* 1258 */
    let title: String /* 1259 */
    let results: [SearchResult] /* 1260 */
}

protocol SearchResultsViewControllerDelegate: AnyObject { /* 1305 */
    func didTapResult(_ result: SearchResult) /* 1306 */
}

class SearchResultsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource { /* 1246 add 2 protocols */
    
    weak var delegate: SearchResultsViewControllerDelegate? /* 1307 */
    
    private var sections: [SearchSection] = [] /* 1236 */ /* 1257 change SearchResult */ /* 1269 change results */
    
    private let tableView: UITableView = { /* 1238 */
        let tableView = UITableView(frame: .zero, style: .grouped) /* 1239 */
        tableView.backgroundColor = .systemBackground /* 1256 */
        tableView.register(SearchResultDefaultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier) /* 1344 */
        tableView.register(SearchResultSubtitleTableViewCell.self, /* 1368 change UITableViewCell */
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier) /* 1240 */ /* 1369 change "cell" */
        tableView.isHidden = true /* 1243 */
        return tableView /* 1241 */
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear /* 1007 */ /* 1234 change .systemBackground */
        view.addSubview(tableView) /* 1242 */
        tableView.delegate = self /* 1244 */
        tableView.dataSource = self /* 1245 */
    }
    
    override func viewDidLayoutSubviews() { /* 1232 */
        super.viewDidLayoutSubviews() /* 1233 */
        tableView.frame = view.bounds /* 1253 */
    }
    
    func update(with results: [SearchResult]) { /* 1235 */
        let artists = results.filter({
            switch $0 { /* 1262 */
            case .artist: /* 1263 */
                return true /* 1265 */
            default: /* 1264 */
                return false /* 1266 */
            }
        }) /* 1261 */
        
        let albums = results.filter({
            switch $0 { /* 1280 */
            case .album: /* 1281 */
                return true /* 1282 */
            default: /* 1281 */
                return false /* 1282 */
            }
        }) /* 1279  */
        
        let tracks = results.filter({
            switch $0 { /* 1284 */
            case .track: /* 1285 */
                return true /* 1286 */
            default: /* 1285 */
                return false /* 1286 */
            }
        }) /* 1283 */
        
        let playlists = results.filter({
            switch $0 { /* 1288 */
            case .playlist: /* 1289 */
                return true /* 1290 */
            default: /* 1289 */
                return false /* 1290 */
            }
        }) /* 1287 */
        
        self.sections = [ /* 1237 */ /* 1267 change results */
            SearchSection(title: "Songs", results: tracks), /* 1268 */
            SearchSection(title: "Artists", results: artists), /* 1291 */
            SearchSection(title: "Playlists", results: playlists), /* 1292 */
            SearchSection(title: "Albums", results: albums), /* 1293 */

            ]
        tableView.reloadData() /* 1254 */
        tableView.isHidden = results.isEmpty /* 1255 hidden if empty */
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { /* 1270 */
        return sections.count /* 1271 */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 1247 */
        return sections[section].results.count /* 1248 */ /* 1272 change results.count  */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 1249 */
        let result = sections[indexPath.section].results[indexPath.row] /* 1273 */
        
//        let Acell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 1250 */
        switch result { /* 1274 */
        case .artist(let artist): /* 1275 */
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultDefaultTableViewCell else { /* 1345 and add as? */
                return UITableViewCell() /* 1346 */
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: artist.name,
                imageURL: URL(string: artist.images?.first?.url ?? "") /* 1351 change nil */
            ) /* 1348 */
            cell.configure(with: viewModel) /* 1349 */
            return cell /* 1347 */
        case .album(let album): /* 1275 */
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else { /* 1370 copy from .artist case and change */
                return UITableViewCell() /* 1370 */
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "",
                imageURL: URL(string: album.images.first?.url ?? "") /* 1370 */
            ) /* 1370 */
            cell.configure(with: viewModel) /* 1370 */
            return cell /* 1370 */
//            Acell.textLabel?.text = model.name /* 1276 */
        case .track(let track): /* 1275 */
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else { /* 1371 copy from .artist case and change */
                return UITableViewCell() /* 1371 */
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "-",
                imageURL: URL(string: track.album?.images.first?.url ?? "") /* 1371 */
            ) /* 1371 */
            cell.configure(with: viewModel) /* 1371 */
            return cell /* 1371 */
//            Acell.textLabel?.text = model.name /* 1276 */
        case .playlist(let playlist): /* 1275 */
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else { /* 1372 copy from .artist case and change */
                return UITableViewCell() /* 1372 */
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? "") /* 1372 */
            ) /* 1372 */
            cell.configure(with: viewModel) /* 1372 */
            return cell /* 1372 */
//            Acell.textLabel?.text = model.name /* 1276 */
        }
//        cell.textLabel?.text = "Foo" /* 1251 */
//        return Acell /* 1252 */
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 1294 */
        tableView.deselectRow(at: indexPath, animated: true) /* 1295 */
        let result = sections[indexPath.section].results[indexPath.row] /* 1296 */
        delegate?.didTapResult(result) /* 1311 */
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? { /* 1277 */
        return sections[section].title /* 1278 */
    }
}
