//
//  Playlist.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

struct Playlist: Codable { /* 422 */
    let description: String /* 433 */
    let external_urls: [String: String] /* 434 */
    let id: String /* 435 */
    let images: [APIImage] /* 436 */
    let name: String /* 437 */
    let owner: User /* 438 */
}
