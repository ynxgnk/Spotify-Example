//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import Foundation

struct SearchResultResponse: Codable { /* 1208 */
    let albums: SearchAlbumResponse /* 1209 */
    let artists: SearchArtistsResponse /* 1212 */
    let playlists: SearchPlaylistsResponse /* 1213 */
    let tracks: SearchTracksResponse /* 1215 */
}

struct SearchAlbumResponse: Codable { /* 1210 */
    let items: [Album] /* 1217 */
}

struct SearchArtistsResponse: Codable { /* 1214 */
    let items: [Artist] /* 1218 */
}

struct SearchPlaylistsResponse: Codable { /* 1211 */
    let items: [Playlist] /* 1219 */
}

struct SearchTracksResponse: Codable { /* 1216 */
    let items: [AudioTrack] /* 1220 */
}
