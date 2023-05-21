//
//  SettingsModels.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

struct Section { /* 284 */
    let title: String /* 285 */
    let options: [Option] /* 286 */
}

struct Option { /* 287 */
    let title: String /* 288 */
    let handler: () -> Void /* 289 */
}
