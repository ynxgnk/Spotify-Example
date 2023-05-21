//
//  Artist.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

struct Artist: Codable { /* 402 */
    let id: String /* 404 */
    let name: String /* 405 */
    let type: String /* 406 */
    let images: [APIImage]? /* 1350 */
    let external_urls: [String: String] /* 407 */
}
