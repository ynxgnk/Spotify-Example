//
//  APICaller.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

final class APICaller { /* 193 */
    static let shared = APICaller() /* 194 */
    
    private init() {} /* 195 */
    
    struct Constants { /* 230 */
        static let baseAPIURL = "https://api.spotify.com/v1" /* 231 */
    }
    
    enum APIError: Error { /* 236 */
        case failedToGetData /* 237 */
    }
    
    //MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) { /* 751 */ /* 783 change String */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            type: .GET
        ) { request in /* 752 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 753 */
                guard let data = data, error == nil else { /* 754 */
                    completion(.failure(APIError.failedToGetData)) /* 757 */
                    return /* 755 */
                }
                
                do { /* 758 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 759 */
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data) /* 780 */
                    
//                    print(result) /* 760 */ /* 781  change json */
                    completion(.success(result)) /* 782 */
                }
                catch { /* 761 */
                    print(error) /* 762 */
                    completion(.failure(error)) /* 763 */
                }
            }
            task.resume() /* 756 */
        }
    }
    
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) { /* 1988 */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/albums"),
            type: .GET
        ) { request in /* 1989 copy from getPlaylistDetails(784) and change */
            print("Getting current albums") /* 2018 */
                let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 1989 */
                    guard let data = data, error == nil else { /* 1989 */
                        completion(.failure(APIError.failedToGetData)) /* 1989 */
                        return /* 1989 */
                    }
                    
                    do { /* 1989 */
//                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 1989 */
                        let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data) /* 1989 */ /* 1993 add LibraryAlbumsResponse */
                        print(result) /* 1990 */
                        completion(.success(result.items.compactMap({ $0.album }))) /* 1989 */ /* 2023 add compactMap */

                    }
                    catch { /* 1989 */
                        print(error) /* 1989 */
                        completion(.failure(error)) /* 1989 */
                    }
                }
            task.resume() /* 1989 */
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) { /* 2005 */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/albums?ids=\(album.id)"),
            type: .PUT
        ) { baseRequest in /* 2006 */
            var request = baseRequest /* 2010 */
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") /* 2011 */
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in /* 2007 copy from getCurrentUserAlbums(1989) and change */
                guard let data = data,
                      let code = (response as? HTTPURLResponse)?.statusCode,
                      error == nil else { /* 2007 */
                    completion(false) /* 2008 */
                    return /* 2007 */
                }
                print(code) /* 2010 */
                completion(code == 200) /* 2009 */
            }
            task.resume() /* 2007 */
        }
    }
    
    //MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) { /* 784 copy from getAlbumDetails (751) and change*/ /* 796 change String */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            type: .GET
        ) { request in /* 784 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 784 */
                guard let data = data, error == nil else { /* 784 */
                    completion(.failure(APIError.failedToGetData)) /* 784 */
                    return /* 784 */
                }
                
                do { /* 784 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 784 */
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data) /* 784 */ /* 795 add PlaylistDetailsResponse and  uncomment */
                    
//                    print(result) /* 784 */
                    completion(.success(result)) /* 784 */
                }
                catch { /* 784 */
                    print(error) /* 784 */
                    completion(.failure(error)) /* 784 */
                }
            }
            task.resume() /* 784 */
        }
    }
    
    public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) { /* 1727 */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/playlists/?limit=50"),
            type: .GET) { request in /* 1731 */
                let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 1732 */
                    guard let data = data, error == nil else { /* 1733 */
                        completion(.failure(APIError.failedToGetData)) /* 1734 */
                        return /* 1735 */
                    }
                    
                    do { /* 1736 */
//                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 1737 */
                        let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data) /* 1750 */
                        completion(.success(result.items)) /* 1751 */
//                        print(result) /* 1738 */ /* 1752 change json */
                    }
                    catch { /* 1739 */
                        print(error) /* 1740 */
                        completion(.failure(error)) /* 1741 */
                    }
                }
                task.resume() /* 1742 */
            }
        }
    
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) { /* 1728 */
        getCurrentUserProfile { [weak self] result in /* 1823 */ /* 1828 add weak self */
            switch result { /* 1824 */
            case .success(let profile): /* 1825 */
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists" /* 1827 */
//                print(urlString) /* 1845 */
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in /* 1829 */
                    var request = baseRequest /* 1840 */
                    let json = [ /* 1843 */
                        "name": name /* 1844 */
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) /* 1841 */
                    print("Starting creation...") /* 1846 */
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 1830 */
                        guard let data = data, error == nil else { /* 1831 */
                            completion(false) /* 1838 */
                            return /* 1832 */
                        }
                        
                        do { /* 1833 */
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 1834 */
//                            let result = try JSONDecoder().decode(Playlist.self, from: data) /* 1847 */
                            if let response = result as? [String: Any], response["id"] as? String != nil { /* 1862 instead of JSONDecoder because: we dont need to hand back a model, we only care if we got a response */
                                print("Created") /* 1866 */
                                completion(true) /* 1863 */
                            }
                            else { /* 1864 */
                                print("Failed to get id") /* 1867 */
                                completion(false) /* 1865 */
                            }
//                            print("Created: \(result)") /* 1842 */
//                            completion(true) /* 1848 */
                        }
                        catch { /* 1835 */
                            print(error.localizedDescription) /* 1836 */
                            completion(false) /* 1837 */
                        }
                    }
                    task.resume() /* 1839 */
                }
            case .failure(let error): /* 1825 */
                print(error.localizedDescription) /* 1826 */
            }
        }
    }
    
    public func addTrackToPlaylist(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) { /* 1729 */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
            type: .POST
        ) { baseRequest in /* 1903 */
            var request = baseRequest /* 1904 */
            let json = [ /* 1905 */
                "uris": [ /* 1906 */
                    "spotify:track:\(track.id)" /* 1906 */
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) /* 1907 */
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") /* 1908 */
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 1909 */
                guard let data = data, error == nil else { /* 1910 */
                    completion(false) /* 1911 */
                    return /* 1912 */
                }
                
                do { /* 1916 */
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 1913 */
//                    print(result) /* 1955 */
                    if let response = result as? [String: Any],
                       response["snapshot_id"] as? String != nil { /* 1914 */
                        completion(true) /* 1915 */
                    }
                    else { /* 1953 */
                        completion(false) /* 1954 */
                    }
                }
                catch { /* 1916 */
                    completion(false) /* 1917 */
                }
            }
            task.resume() /* 1918 */
        }
    }
    
    public func removeTrackFromPlaylist(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) { /* 1956 copy from addTrackToPlaylist(1730) add change */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
            type: .DELETE
        ) { baseRequest in /* 1956 */
            var request = baseRequest /* 1956 */
            let json: [String: Any] = [ /* 1956 */
                "tracks": [ /* 1956 change uris */
                    [
                    "uri": "spotify:track:\(track.id)" /* 1956 add uri */
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) /* 1956 */
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") /* 1956 */
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 1956 */
                guard let data = data, error == nil else { /* 1956 */
                    completion(false) /* 1956 */
                    return /* 1956 */
                }
                
                do { /* 1956 */
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 1956 */
//                    print(result) /* 1956 */
                    if let response = result as? [String: Any],
                       response["snapshot_id"] as? String != nil { /* 1956 */
                        completion(true) /* 1956 */
                    }
                    else { /* 1956 */
                        completion(false) /* 1956 */
                    }
                }
                catch { /* 1956 */
                    completion(false) /* 1956 */
                }
            }
            task.resume() /* 1956 */
        }
    }
    
    //MARK: - Profile
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) { /* 197 */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"), /* 232 add baseAPIURL */
            type: .GET
        ) { baseRequest in /* 229 */
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in /* 233 */
                guard let data = data, error == nil else { /* 234 */
                    completion(.failure(APIError.failedToGetData)) /* 238 */
                    return /* 235 */
                }
                
                do { /* 239 */
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 242 */
                    let result = try JSONDecoder().decode(UserProfile.self, from: data) /* 260 */
//                    print(result) /* 243 */
                    completion(.success(result))
                }
                catch { /* 240 */
                    print(error.localizedDescription) /* 262 */
                    completion(.failure(error)) /* 241 */
                }
            }
            task.resume() /* 249 */
        }
    }
    
    //MARK: - Browse
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) { /* 373 */ /* 410 change String to New...Response*/
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in /* 374 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 375 */
                guard let data = data, error == nil else { /* 376 */
                    completion(.failure(APIError.failedToGetData)) /* 377 */
                    return /* 378 */
                }
                
                do { /* 379 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 380 */
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data) /* 408 */
//                    print(result) /* 381 */ /* 411 change json */
                    completion(.success(result)) /* 409 */
                }
                catch { /* 382 */
                    completion(.failure(error)) /* 383 */
                }
            }
            task.resume() /* 384 */
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>) -> Void)) { /* 412 */ /* 445 change String to Featured...Response */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), /* 696 change limit from 2 to 20 */
            type: .GET
        ) { request in /* 413 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 414 copy from getNewReleases */
                guard let data = data, error == nil else { /* 414 */
                    completion(.failure(APIError.failedToGetData)) /* 414 */
                    return /* 414 */
                }
                
                do { /* 414 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 415 */
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data) /* 414 */ /* 443 change to FeaturedPlaylistsResponse and uncomment */
//                    print(result) /* 416 */
                    completion(.success(result)) /* 444 */
                }
                catch { /* 414 */
                    completion(.failure(error)) /* 414 */
//                    print("\n\n\n HERE ERROR! \n\n\n") /* 
                }
            }
            task.resume() /* 414 */
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) { /* 446 */ /* 456 add genres */ /* 482 change String to RecommendationsResponse */
        let seeds = genres.joined(separator: ",") /* 458 */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"), /* 457 add ?seed_genres=\(seeds) */ /* 466 add limit=2& */
            type: .GET
        ) { request in /* 447 */
//            print(request.url?.absoluteString) /* 465 */
//            print("Starting recommendations api call...") /* 449 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 448 copy from getFeaturedPlaylists */
                guard let data = data, error == nil else { /* 448 */
                    completion(.failure(APIError.failedToGetData)) /* 448 */
                    return /* 448 */
                }

                do { /* 448 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 448 */
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data) /* 448 */ /* 480 change Featured..Response to RecommendationsResponse and uncomment */
//                    print(result) /* 448 */ /* 481 change json */
                    completion(.success(result)) /* 448 */
                }
                catch { /* 448 */
                    completion(.failure(error)) /* 448 */
                }
            }
            task.resume() /* 448 */
        }
    }
    
    public func getRecommendedGenres(completion: @escaping((Result<RecommendedGenresResponse, Error>) -> Void)) { /* 450 */ /* 455 change String to RecommendedgenresResponse */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
            type: .GET
        ) { request in /* 451 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 452 copy from getNewReleases */
                guard let data = data, error == nil else { /* 452 */
                    completion(.failure(APIError.failedToGetData)) /* 452 */
                    return /* 452 */
                }
                
                do { /* 452 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 452 */
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data) /* 452 */
//                    print(result) /* 452 */
                    completion(.success(result)) /* 452 */
                }
                catch { /* 452 */
                    completion(.failure(error)) /* 452 */
                }
            }
            task.resume() /* 452 */
        }
    }
    
    //MARK: - Category
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) { /* 1074 */ /* 1098 change String to [Category] */
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"),
                      type: .GET
        ) { request in /* 1075 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 1076 */
                guard let data = data, error == nil else { /* 1077 */
                    completion(.failure(APIError.failedToGetData)) /* 1078 */
                    return /* 1079 */
                }
                do { /* 1081 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 1083 */
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self,
                                                          from: data) /* 1099 */
//                    print(result.categories.items) /* 1084 */ /* 1101 change json */ /* 1105 */
                    completion(.success(result.categories.items)) /* 1100 */ /* 1105 add categories */
                }
                catch { /* 1082 */
                    print(error.localizedDescription) /* 1102 */
                    completion(.failure(error)) /* 1085 */
                }
            }
            task.resume() /* 1080 */
        }
    }
    
    public func getCategoryPlaylist(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) { /* 1086 copy from getCategories and change */ /* 1106 add category */
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"), /* 1107 add \(category.id)/playlists */
                      type: .GET
        ) { request in /* 1086 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 1086 */
                guard let data = data, error == nil else { /* 1086 */
                    completion(.failure(APIError.failedToGetData)) /* 1086 */
                    return /* 1086 */
                }
                do { /* 1081 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 1086 */
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self,
                                                          from: data) /* 1111 */
                    let playlists = result.playlists.items /* 1114 */
                    completion(.success(playlists)) /* 1113 */
//                    print(playlists) /* 1086 */ /* 1112 change json */ /* 1117 change result */
                }
                catch { /* 1082 */
                    print(error.localizedDescription) /* 1108 */
                    completion(.failure(error)) /* 1086 */
                }
            }
            task.resume() /* 1086 */
        }
    }
    
    //MARK: - Search
    
    public func search(with query: String, completion: @escaping(Result<[SearchResult], Error>) -> Void) { /* 1184 */ /* 1225 change String to SearchResult */
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), /* 1196 add type... */ /* 1203 add limit */
            type: .GET
        ) { request in /* 1185 */
            print(request.url?.absoluteString ?? "none") /* 1197 */
            let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 1186 */
                guard let data = data, error == nil else { /* 1187 */
                    completion(.failure(APIError.failedToGetData)) /* 1189 */
                    return /* 1188 */
                }
                do { /* 1190 */
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) /* 1192 */
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data) /* 1221 */
                    
                    var searchResults: [SearchResult] = [] /* 1226 */
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) })) /* 1227 means: take all the tracks and convert them to one type SearchResult, and add into searchResults */
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) })) /* 1228 */
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) })) /* 1229 */
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) })) /* 1230 */
                    
                    completion(.success(searchResults)) /* 1231 */
//                    print(result) /* 1193 */ /* 1222 change json */
                }
                catch { /* 1191 */
                    print(error)
                    completion(.failure(error)) /* 1194 */
                    
                }
            }
            task.resume() /* 1195 */
        }
    }
    
    //MARK: - Private
    
    enum HTTPMethod: String { /* 224 */
        case GET /* 225 */
        case POST /* 225 */
        case DELETE /* 1957 */
        case PUT /* 2004 */
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod, /* 226 add type */
        completion: @escaping (URLRequest) -> Void
    ) { /* 218 */
        AuthManager.shared.withValidToken { token in /* 217 */
            guard let apiURL = url else { /* 219 */
                return /* 220 */
            }
            var request = URLRequest(url: apiURL) /* 221 */
            request.setValue("Bearer \(token)",
                          forHTTPHeaderField: "Authorization") /* 222 */
            request.httpMethod = type.rawValue /* 227 */
            request.timeoutInterval  = 30 /* 228 */
            completion(request) /* 223 */
        }
    }
}
