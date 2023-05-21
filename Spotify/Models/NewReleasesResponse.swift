//
//  NewReleasesResponse.swift
//  
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

struct NewReleasesResponse: Codable { /* 390 */
    let albums: AlbumsResponse /* 392 */
}

struct AlbumsResponse: Codable { /* 391 */
    let items: [Album] /* 393 */
}

struct Album: Codable { /* 394 */
    let album_type: String /* 395 */
    let available_markets: [String] /* 396 */
    let id: String /* 397 */
    var images: [APIImage] /* 398 */ /* 1618 change to var */
    let name: String /* 399 */
    let release_date: String /* 400 */
    let total_tracks: Int /* 401 */
    let artists: [Artist] /* 403 */
}


