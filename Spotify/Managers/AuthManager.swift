//
//  AuthManager.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

final class AuthManager { /* 30 */
    static let shared = AuthManager() /* 31 */
    
    private var refreshingToken = false /* 206 */
    
    struct Constants { /* 59 */
        static let clientID = "eb2db6b55ff841368adc8270c5e88be2" /* 60 */
        static let clientSecret = "6bc97ccc0b9b4b3d895fd0b8f1c90434" /* 61 */ 
        static let tokenAPIURL = "https://accounts.spotify.com/api/token" /* 123 */
        static let redirectURI = "https://www.iosacademy.io" /* 101 */
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email" /* 100 */ /* 192 add %20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email */ 

    }
    
    private init() {} /* 32 */
    
    public var signInURL: URL? { /* 99 */
        let base = "https://accounts.spotify.com/authorize" /* 102 */
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE" /* 103 */
        return URL(string: string) /* 104 */
    }
    
    var isSignedIn: Bool { /* 33 */
        return accessToken != nil /* 34 */ /* 164 change false */
    }
    
    private var accessToken: String? { /* 35 access */
        return UserDefaults.standard.string(forKey: "access_token") /* 36 */ /* 165 change nil */
    }
    
    private var refreshToken: String? { /* 37 */
        return UserDefaults.standard.string(forKey: "refresh_token") /* 38 */ /* 166 change nil */
    }
    
    private var tokenExpirationDate: Date? { /* 39 */
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date /* 40 */ /* 167 change nil */
    }
    
    private var shouldRefreshToken: Bool { /* 41 */
        guard let expirationDate = tokenExpirationDate else { /* 168 */
            return false /* 169 */
        }
        let currentDate = Date() /* 170 */
        let fiveMinutes: TimeInterval = 300 /* 171 */
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate /* 42 */ /* 172 change false */
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) { /* 115 */
        //Get token
        guard let url = URL(string: Constants.tokenAPIURL) else { /* 124 */
            return /* 125 */
        }
        
        var components = URLComponents() /* 139 */
        components.queryItems = [ /* 140 */
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"), /* 141 */
            URLQueryItem(name: "code",
                         value: code), /* 142 */
            URLQueryItem(name: "redirect_uri",
                         value: Constants.redirectURI), /* 143 */
        ]
        
        var request = URLRequest(url: url) /* 126 */
        request.httpMethod = "POST" /* 127 */
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type") /* 145 */
        request.httpBody = components.query?.data(using: .utf8) /* 144 */
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret /* 147 */
        let data = basicToken.data(using: .utf8) /* 148 */
        guard let base64string = data?.base64EncodedString() else { /* 149 */
            print("Failure to get base64") /* 150 */
            completion(false) /* 151 */
            return /* 152 */
        }
        
        request.setValue("Basic \(base64string)", /* 153 add base64String */
                         forHTTPHeaderField: "Authorization") /* 146 */
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in /* 128 */ /* 159 add weak self */
            guard let data = data,
                  error == nil else { /* 129 */
                completion(false) /* 132 */
                return /* 130 */
            }
            
            do { /* 133 */
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 135 */
//                  print("SUCCESS: \(json)") /* 136 */
                let result = try JSONDecoder().decode(AuthResponse.self, from: data) /* 156 */
                self?.cacheToken(result: result) /* 157 */
                completion(true) /* 158 */
            }
            catch { /* 134 */
                print(error.localizedDescription) /* 137 */
                completion(false) /* 138 */
            }
        }
        task.resume() /* 131 */
    }
    
    private var onrefreshBlocks = [((String) -> Void)]() /* 213 */
    
    ///Supplies valid token to be used with API Calls 
    public func withValidToken(completion: @escaping (String) -> Void) { /* 198 */
        guard !refreshingToken else { /* 211 */
            //Append the comletion
            onrefreshBlocks.append(completion) /* 214 */
            return /* 212 */
        }
        if shouldRefreshToken { /* 199 */
            //Refresh
            refreshIfNeeded { [weak self] success in /* 202 */ /* 205 add weak self */
                    if let token = self?.accessToken, success { /* 203 */
                        completion(token) /* 204 */
                    }
                }
            }
        
        else if let token = accessToken { /* 200 */
            completion(token) /* 201 */
        }
    }
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) { /* 116 */ /* 368 make completion optional and remove escaping  */
        guard !refreshingToken else { /* 208 */
            return /* 209 */
        }
        guard shouldRefreshToken else { /* 183 */
            completion?(true) /* 184 */
            return /* 185 */
        }
        
        guard let refreshToken = self.refreshToken else { /* 181 */
            return /* 182 */
        }
        
        //Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else { /* 186 copy from exchangeCodeForToken (124) */
            return /* 186 */
        }
        
        refreshingToken = true /* 207 */
        
        var components = URLComponents() /* 186 */
        components.queryItems = [ /* 186 */
            URLQueryItem(name: "grant_type",
                         value: "refresh_token"), /* 187 change authorization_code */
            URLQueryItem(name: "refresh_token", /* 188 change redirect_uri */
                         value: refreshToken), /* 189 add refreshToken */
        ]
        
        var request = URLRequest(url: url) /* 186 */
        request.httpMethod = "POST" /* 186 */
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type") /* 186 */
        request.httpBody = components.query?.data(using: .utf8) /* 186 */
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret /* 186 */
        let data = basicToken.data(using: .utf8) /* 186 */
        guard let base64string = data?.base64EncodedString() else { /* 186 */
            print("Failure to get base64") /* 186 */
            completion?(false) /* 186 */
            return /* 186 */
        }
        
        request.setValue("Basic \(base64string)", /* 186 */
                         forHTTPHeaderField: "Authorization") /* 186 */
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in /* 186 */
            self?.refreshingToken = false /* 210 */
            guard let data = data,
                  error == nil else { /* 186 */
                completion?(false) /* 186 */
                return /* 186 */
            }
            
            do { /* 186 */
                let result = try JSONDecoder().decode(AuthResponse.self, from: data) /* 186 */
//                print("Successfully refreshed!") /* 190 */
                self?.onrefreshBlocks.forEach { $0(result.access_token) } /* 215 */
                self?.onrefreshBlocks.removeAll() /* 216 */
                self?.cacheToken(result: result) /* 186 */
                completion?(true) /* 186 */
            }
            catch { /* 186 */
                print(error.localizedDescription) /* 186 */
                completion?(false) /* 186 */
            }
        }
        task.resume() /* 186 */
    }
    
    
    public func cacheToken(result: AuthResponse) { /* 117 */ /* 160 add parameter result */
        UserDefaults.standard.setValue(result.access_token,
                                       forKey: "access_token") /* 161 */
        if let refresh_token = result.refresh_token { /* 191 */
            UserDefaults.standard.setValue(refresh_token,
                                           forKey: "refresh_token") /* 162 */
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate") /* 163 */
    }
    
    public func signOut(completion: (Bool) -> Void) { /* 2056 */
        UserDefaults.standard.setValue(nil,
                                       forKey: "access_token") /* 2057 */
        UserDefaults.standard.setValue(nil,
                                       forKey: "refresh_token") /* 2058 */
        UserDefaults.standard.setValue(nil,
                                       forKey: "expirationDate") /* 2059 */
        
        completion(true) /* 2060 */
    }
}
