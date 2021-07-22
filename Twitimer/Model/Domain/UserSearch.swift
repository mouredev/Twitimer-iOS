//
//  UserSearch.swift
//  Twitimer
//
//  Created by Brais Moure on 19/6/21.
//

import Foundation

struct UsersSearch: Decodable {
    
    let data: [UserSearch]?
    
}

struct UserSearch: Decodable {
    
    let id: String?
    let broadcasterLogin: String?
    let displayName: String?
    let thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case broadcasterLogin = "broadcaster_login"
        case displayName = "display_name"
        case thumbnailUrl = "thumbnail_url"
    }
    
}
