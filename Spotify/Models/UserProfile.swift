//
//  Profile.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

struct UserProfile: Codable { /* 196 */
    let country: String /* 256 */
    let display_name: String /* 256 */
    let email: String /* 256 */
    let explicit_content: [String: Bool] /* 256 */
    let external_urls: [String: String] /* 256 */
    let id: String /* 256 */
    let product: String /* 256 */
    let images: [APIImage] /* 259 */
}


