//
//  AuthViewController.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import UIKit
import WebKit /* 64 */

class AuthViewController: UIViewController, WKNavigationDelegate { /* 71 add protocol */

    private let webView: WKWebView = { /* 62 */
        let prefs = WKWebpagePreferences() /* 63 */
        prefs.allowsContentJavaScript = true /* 64 */
        let config = WKWebViewConfiguration() /* 65 */
        config.defaultWebpagePreferences = prefs /* 66 */
        let webView = WKWebView(frame: .zero, configuration: config) /* 67 */
        return webView /* 68 */
    }()
    
    public var completionHandler: ((Bool) -> Void)? /* 94 is gonna tell WelcomeVC that the user has successfully signed in */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In" /* 62 */
        view.backgroundColor = .systemBackground /* 63 */
        webView.navigationDelegate = self /* 69 */
        view.addSubview(webView) /* 70 */
        guard let url = AuthManager.shared.signInURL else { /* 106 */
            return /* 107 */
        }
        webView.load(URLRequest(url: url)) /* 108 */
    }
    
    override func viewDidLayoutSubviews() { /* 72 */
        super.viewDidLayoutSubviews() /* 73 */
        webView.frame = view.bounds /* 74 */
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { /* 109 */
        guard let url = webView.url else { /* 110 */
            return /* 111 */
        }
        //Exchange the code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"})?.value else { /* 112 */
            return /* 113 */
        }
        webView.isHidden = true /* 119 */
        
//        print("Code: \(code)") /* 114 */
        AuthManager.shared.exchangeCodeForToken(code: code, completion: { [weak self] success in /* 118 */
            DispatchQueue.main.async { /* 122 */
                self?.navigationController?.popToRootViewController(animated: true) /* 121 */
                self?.completionHandler?(success) /* 120 */
            }
        })
    }
}
