//
//  SceneDelegate.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let widnowScene = (scene as? UIWindowScene) else { return } /* 12 change _ to windowScene */
        
        let window = UIWindow(windowScene: widnowScene) /* 8 */
                
        if AuthManager.shared.isSignedIn { /* 46 */
            window.rootViewController = TabBarViewController() /* 10 */
        }
        else { /* 47 */
            let navVC = UINavigationController(rootViewController: WelcomeViewController()) /* 55 */
            navVC.navigationBar.prefersLargeTitles = true /* 57 */
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always /* 58 */
            window.rootViewController = navVC /* 48 */ /* 56 change code to navVC */
        }
        
        window.makeKeyAndVisible() /* 9 */
        self.window = window /* 11 */
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

