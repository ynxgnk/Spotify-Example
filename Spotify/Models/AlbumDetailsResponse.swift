//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 30.04.2023.
//

import Foundation

struct AlbumDetailsResponse: Codable { /* 768 */
    let album_type: String /* 769 */
    let artists: [Artist] /* 770 */
    let available_markets: [String] /* 771 */
    let external_urls: [String: String] /* 772 */
    let id: String /* 773 */
    let images: [APIImage] /* 774 */
    let label: String /* 775 */
    let name: String /* 776 */
    let tracks: TracksResponse /* 779 */
}

struct TracksResponse: Codable { /* 777 */
    let items: [AudioTrack] /* 778 */
}
