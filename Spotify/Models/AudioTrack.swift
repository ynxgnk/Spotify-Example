//
//  AudioTrack.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

struct AudioTrack: Codable { /* 469 */
    var album: Album? /* 470 */ /* 1617 change to var */
    let artists: [Artist] /* 471 */
    let available_markets: [String] /* 472 */
    let disc_number: Int /* 473 */
    let duration_ms: Int /* 474 */
    let explicit: Bool /* 475 */
    let external_urls: [String: String] /* 476 */
    let id: String /* 477 */
    let name: String /* 478 */
    let preview_url: String? /* 1539 */
//    let popularity: Int? /* 479 */
}
