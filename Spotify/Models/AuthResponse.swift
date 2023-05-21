//
//  AuthResponse.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation

struct AuthResponse: Codable { /* 154 */
    let access_token: String /* 155 */
    let expires_in: Int /* 155 */
    let refresh_token: String? /* 155 */
    let scope: String /* 155 */
    let token_type: String /* 155 */
}
   


