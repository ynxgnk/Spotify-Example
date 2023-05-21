//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import Foundation

struct AllCategoriesResponse: Codable { /* 1092 */
    let categories: Categories /* 1103 */
}

struct Categories: Codable { /* 1104 */
    let items: [Category] /* 1093 */
}

struct Category: Codable { /* 1094 */
    let id: String /* 1095 */
    let name: String /* 1096 */
    let icons: [APIImage] /* 1097 */
}
