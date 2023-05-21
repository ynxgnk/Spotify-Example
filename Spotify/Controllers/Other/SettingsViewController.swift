//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { /* 275 add 2 protocols */
    
    private let tableView: UITableView = { /* 265 */
        let tableView = UITableView(frame: .zero, style: .grouped) /* 266 */
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell") /* 267 */
        return tableView /* 268 */
    }()
    
    private var sections = [Section]() /* 290 */

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels() /* 292 */
        title = "Settings" /* 263 */
        view.backgroundColor = .systemBackground /* 264 */
        view.addSubview(tableView) /* 269 */
        tableView.dataSource = self /* 270 */
        tableView.delegate = self /* 271 */
    }
    
    private func configureModels() { /* 291 */
        sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile",handler: { [weak self] in /* 293 and add weak self */
            DispatchQueue.main.async { /* 294 */
                self?.viewProfile() /* 295 */
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out",handler: { [weak self] in /* 301 and add weak self */
            DispatchQueue.main.async { /* 302 */
                self?.signOutTapped() /* 303 */
            }
        })]))
    }
    
    private func signOutTapped() { /* 304 */
        let alert = UIAlertController(title: "Sign Out",
                                      message: "Are you sure?",
                                      preferredStyle: .alert) /* 2071 */
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) /* 2073 */
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in /* 2074 */
            AuthManager.shared.signOut { [weak self] signedOut in /* 2061 */ /* 2069 add weak self */
                if signedOut { /* 2062 */
                    DispatchQueue.main.async { /* 2063 */
                        let navVC = UINavigationController(rootViewController: WelcomeViewController()) /* 2064 */
                        navVC.navigationBar.prefersLargeTitles = true /* 2065 */
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always /* 2066 */
                        navVC.modalPresentationStyle = .formSheet /* 2068 */
                        self?.present(navVC, animated: true, completion: { /* 2067 */
                            self?.navigationController?.popToRootViewController(animated: false) /* 2070 */
                        })
                    }
                }
            }
        }))
        present(alert, animated: true) /* 2072 */
    }
    
    private func viewProfile() { /* 296 */
        let vc = ProfileViewController() /* 297 */
        vc.title = "Profile" /* 298 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 299 */
        navigationController?.pushViewController(vc, animated: true) /* 300 */
    }
    
    override func viewDidLayoutSubviews() { /* 272 */
        super.viewDidLayoutSubviews() /* 273 */
        tableView.frame = view.bounds /* 274 */
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int { /* 276 */
        return sections.count /* 305 */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 277 */
        return sections[section].options.count /* 306 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 278 */
        let model = sections[indexPath.section].options[indexPath.row] /* 307 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 279 */
        cell.textLabel?.text = model.title /* 280 */ /* 313 change "Foo" */
        return cell /* 281 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 282 */
        tableView.deselectRow(at: indexPath, animated: true) /* 283 */
        //Call handler for cell
        let model = sections[indexPath.section].options[indexPath.row] /* 308 */
        model.handler() /* 309 */
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { /* 310 */
        let model = sections[section] /* 311 */
        return model.title /* 312 */
    }
}
