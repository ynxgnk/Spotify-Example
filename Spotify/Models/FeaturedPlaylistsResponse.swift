//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable { /* 418 */
    let playlists: PlaylistResponse /* 419 */
}

struct CategoryPlaylistsResponse: Codable { /* 1115 */
    let playlists: PlaylistResponse /* 1116 */
}

struct PlaylistResponse: Codable { /* 420 */
    let items: [Playlist] /* 421 */
}

struct User: Codable { /* 439 */
    let display_name: String /* 440 */
    let external_urls: [String: String] /* 441 */
    let id: String /* 442 */
}
