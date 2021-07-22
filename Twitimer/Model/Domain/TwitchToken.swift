//
//  TwitchToken.swift
//  Twitimer
//
//  Created by Brais Moure on 25/4/21.
//

import Foundation

struct TwitchToken: Codable {
    
    let accessToken: String?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {

        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }

}
