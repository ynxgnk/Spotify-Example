//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 03.05.2023.
//

import Foundation

struct LibraryAlbumsResponse: Codable { /* 1991 */
    let items: [SavedAlbum] /* 1992 */ /* 2022 change Album */
}

struct SavedAlbum: Codable { /* 2019 */
    let added_at: String /* 2021 */
    let album: Album /* 2020 */
}
