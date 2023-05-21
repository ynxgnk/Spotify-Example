//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = { /* 81 */
       let button = UIButton() /* 82 */
        button.backgroundColor = .white /* 83 */
        button.setTitle("Sign In with Spotify", for: .normal) /* 84 */
        button.setTitleColor(.black, for: .normal) /* 85 */
        return button /* 86 */
    }()
    
    private let imageView: UIImageView = { /* 2075 */
        let imageView = UIImageView() /* 2076 */
        imageView.contentMode = .scaleAspectFill /* 2077 */
        imageView.image = UIImage(named: "albums_background") /* 2079 */
        return imageView /* 2078 */
    }()
    
    private let overlayView: UIView = { /* 2082 */
        let view = UIView() /* 2083 */
        view.backgroundColor = .black /* 2084 */
        view.alpha = 0.7 /* 2085 */
        return view /* 2086 */
    }()
    
    private let logoImageView: UIImageView = { /* 2089 */
        let imageView = UIImageView(image: UIImage(named: "logo")) /* 2090 */
        imageView.contentMode = .scaleAspectFit /* 2091 */
        return imageView /* 2092 */
    }()
    
    private let label: UILabel = { /* 2093 */
        let label = UILabel() /* 2094 */
        label.numberOfLines = 0 /* 2097 */
        label.textAlignment = .center /* 2104 */
        label.textColor = .white /* 2098 */
        label.font = .systemFont(ofSize: 32, weight: .semibold) /* 2099 */
        label.text = "Listen to Millions\n of Songs on\n the go." /* 2095 */
        return label /* 2096 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify" /* 49 */
        view.addSubview(imageView) /* 2080 */
        view.addSubview(overlayView) /* 2087 */
        view.backgroundColor = .blue /* 50 */
        view.addSubview(signInButton) /* 87 */
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside) /* 88 */
        view.addSubview(label) /* 2100 */
        view.addSubview(logoImageView) /* 2101 */
    }
    
    override func viewDidLayoutSubviews() { /* 75 */
        super.viewDidLayoutSubviews() /* 76 */
        imageView.frame = view.bounds /* 2081 */
        overlayView.frame = view.bounds /* 2089 */
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        ) /* 89 */
        
        logoImageView.frame = CGRect(x: (view.width-120)/2, y: (view.height-350)/2, width: 120, height: 120) /* 2102 */
        label.frame = CGRect(x: 30, y: logoImageView.bottom+30, width: view.width-60, height: 150) /* 2103 */
    }
    
    @objc func didTapSignIn() { /* 77 */
        let vc = AuthViewController() /* 78 */
        vc.completionHandler = { [weak self] success in /* 95 */
            DispatchQueue.main.async { /* 96 */
                self?.handleSignIn(success: success) /* 97 */
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never /* 79 */
        navigationController?.pushViewController(vc, animated: true) /* 80 */
    }
    
    private func handleSignIn(success: Bool) { /* 98 */
        //Log user in or yell at them for error
        guard success else { /* 173 */
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in.",
                                          preferredStyle: .alert) /* 178 */
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)) /* 179 */
            present(alert, animated: true) /* 180 */
            return /* 174 */
        }
        
        let mainAppTabBarVC = TabBarViewController() /* 175 */
        mainAppTabBarVC.modalPresentationStyle = .fullScreen /* 176 */
        present(mainAppTabBarVC, animated: true) /* 177 */
    }
}
