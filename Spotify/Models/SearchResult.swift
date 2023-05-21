//
//  SearchResult.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import Foundation

enum SearchResult { /* 1223 */
    case artist(model: Artist) /* 1224 */
    case album(model: Album) /* 1224 */
    case track(model: AudioTrack) /* 1224 */
    case playlist(model: Playlist) /* 1224 */
}
