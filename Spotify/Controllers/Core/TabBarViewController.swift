//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = HomeViewController() /* 13 */
        let vc2 = SearchViewController() /* 14 */
        let vc3 = LibraryViewController() /* 15 */
        
        vc1.title = "Browse" /* 24 */
        vc2.title = "Search" /* 24 */
        vc3.title = "Library" /* 24 */
        
        vc1.navigationItem.largeTitleDisplayMode = .always /* 16 */
        vc2.navigationItem.largeTitleDisplayMode = .always /* 16 */
        vc3.navigationItem.largeTitleDisplayMode = .always /* 16 */
        
        let nav1 = UINavigationController(rootViewController: vc1) /* 17 NavigationController - a controller, in which we have a TitleBar, NavigationBar and we can navigate between other controllers */
        let nav2 = UINavigationController(rootViewController: vc2) /* 18 */
        let nav3 = UINavigationController(rootViewController: vc3) /* 19 */
        
        nav1.navigationBar.tintColor = .label /* 370 to make label in balck mode black and in white white */
        nav2.navigationBar.tintColor = .label /* 371 to make label in balck mode black and in white white */
        nav3.navigationBar.tintColor = .label /* 372 to make label in balck mode black and in white white */

        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1) /* 27 */
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1) /* 28 */
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1) /* 29 */
        
        nav1.navigationBar.prefersLargeTitles = true /* 20 */
        nav2.navigationBar.prefersLargeTitles = true /* 21 */
        nav3.navigationBar.prefersLargeTitles = true /* 22 */
        
        setViewControllers([nav1, nav2, nav3], animated: false) /* 23 */
    }
    
    
}
