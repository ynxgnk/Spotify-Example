//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit
import SDWebImage /* 357 */

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { /* 334 add 2 protocols */

    private let tableView: UITableView = { /* 330 */
       let tableView = UITableView() /* 331 */
        tableView.isHidden = true /* 335 */
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell") /* 332 */
        return tableView /* 333 */
    }()
    
    private var models = [String]() /* 350 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile" /* 244 */
        tableView.delegate = self /* 340 */
        tableView.dataSource = self /* 341 */
        view.addSubview(tableView) /* 336 */
        fetchProfile() /* 315 */
        view.backgroundColor = .systemBackground /* 316 */
    }
    
    override func viewDidLayoutSubviews() { /* 337 */
        super.viewDidLayoutSubviews() /* 338 */
        tableView.frame = view.bounds /* 339 */
    }
   
    private func fetchProfile() { /* 314 */
        APICaller.shared.getCurrentUserProfile { [weak self] result in /* 245 */ /* 317 add weak self */
            DispatchQueue.main.async { /* 318 */
//                self?.failedToGetProfile() /* 329 */
                switch result { /* 246 */
                case .success(let model): /* 247 */
                    self?.updateUI(with: model) /* 248 */ /* 320 change break */
                case .failure(let error): /* 247 */
                    print("Profile Error: \(error.localizedDescription)") /* 248 */
                    self?.failedToGetProfile() /* 322 */
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile) { /* 319 */
        tableView.isHidden = false /* 342 */
        //configure table models
        models.append("Full Name: \(model.display_name)") /* 351 */
        models.append("Email Adress: \(model.email)") /* 351 */
        models.append("User ID: \(model.id)") /* 351 */
        models.append("Plan: \(model.product)") /* 351 */
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData() /* 343 */
    }
    
    private func createTableHeader(with string: String?) { /* 354 */
        guard let urlString = string, let url = URL(string: urlString) else { /* 355 */
            return /* 356 */
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5)) /* 358 */
        
        let imageSize: CGFloat = headerView.height/2 /* 360 */
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize)) /* 361 */
        headerView.addSubview(imageView) /* 362 */
        imageView.center = headerView.center /* 363 */
        imageView.contentMode = .scaleAspectFill /* 364 */
        imageView.sd_setImage(with: url, completed: nil) /* 365 */
        imageView.layer.masksToBounds = true /* 366 */
        imageView.layer.cornerRadius = imageSize/2 /* 367 */
        
        tableView.tableHeaderView = headerView /* 359 */
    }
    
    private func failedToGetProfile() { /* 321 */
        let label = UILabel(frame: .zero) /* 323 */
        label.text = "Failed to load Profile." /* 324 */
        label.sizeToFit() /* 325 */
        label.textColor = .secondaryLabel /* 326 */
        view.addSubview(label) /* 327 */
        label.center = view.center /* 328 */
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 344 */
        return models.count /* 352 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 345 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 346 */
        cell.textLabel?.text = models[indexPath.row] /* 347 */ /* 353 change "Foo" */
        cell.selectionStyle = .none /* 348 */
        return cell /* 349 */
    }
}
