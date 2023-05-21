//
//  AppDelegate.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? /* 3 */

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds) /* 4 */
        
        if AuthManager.shared.isSignedIn { /* 43 */
            AuthManager.shared.refreshIfNeeded(completion: nil) /* 369 */
            window.rootViewController = TabBarViewController() /* 6 */
        }
        else { /* 44 */
            let navVC = UINavigationController(rootViewController: WelcomeViewController()) /* 51 */
            navVC.navigationBar.prefersLargeTitles = true /* 54 */
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always /* 53 */
            window.rootViewController = navVC /* 45 */ /* 52 change code to navVC */
        }
        
        window.makeKeyAndVisible() /* 5 */
        self.window = window /* 7 */

//        print(AuthManager.shared.signInURL?.absoluteString) /* 105 */
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

