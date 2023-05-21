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
}
