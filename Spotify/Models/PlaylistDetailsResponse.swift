//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 30.04.2023.
//

import Foundation

struct PlaylistDetailsResponse: Codable { /* 788 */
    let description: String /* 789 */
    let external_urls: [String: String] /* 790 */
    let id: String /* 791 */
    let images: [APIImage] /* 792 */
    let name: String /* 793 */
    let tracks: PlaylistTracksResponse /* 794 */ /* 798 change Tracksresponse */
}

struct PlaylistTracksResponse: Codable { /* 797 */
    let items: [PlaylistItem] /* 799 */
}

struct PlaylistItem: Codable { /* 800 */
    let track: AudioTrack /* 801 */
}
