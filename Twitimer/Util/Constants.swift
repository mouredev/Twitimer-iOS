//
//  Constants.swift
//  Twitimer
//
//  Created by Brais Moure on 19/4/21.
//

import Foundation

struct Constants {

    // Twitch
    static let kTwitchAuthUri = "https://id.twitch.tv/oauth2/"
    static let kTwitchAPIUri = "https://api.twitch.tv/helix/"
    static let kTwitchProfileUri = "https://www.twitch.tv/"
    static let kTwitchRedirectUri = "https://twitimer.com"
    static let kTwitchRedirectHost = "twitimer.com"
    
    // Remote
    static let kRemoteTwitchClientID = "TwitchClientID"
    static let kRemoteTwitchClientSecret = "TwitchClientSecret"
    
    // Generic
    static let kMaxStreamers = 20
    static let kAdminLogin = "mouredev"
    
    // Remote notifications
    static let kMainNotificationTopic = "all"
    static let kStreamerNotificationTopic = "streamer"
    static let kNoStreamerNotificationTopic = "nostreamer"
    
    // Locale
    static let kDefaultLocale = Locale(identifier: "en_US_POSIX")
    static let kJsonDateFormat = "MMM d, yyyy HH:mm:ss"
    
    // Networks
    static let kTwitimerUri = "https://twitimer.com"
    static let kTwitchMoureDevUri = "https://twitch.tv/mouredev"
    static let kDiscordMoureDevUri = "https://discord.gg/U3KjjfUfUJ"
    static let kYouTubeMoureDevUri = "https://youtube.com/mouredevapps"
    static let kTwitterMoureDevUri = "https://twitter.com/mouredev"
    static let kInstagramMoureDevUri = "https://instagram.com/mouredev"
    static let kTikTokMoureDevUri = "https://tiktok.com/@mouredev"
    static let kGitHubMoureDevUri = "https://github.com/mouredev"
    static let discordUri = "https://discord.gg/"
    static let youtubeUri = "https://youtube.com/"
    static let twitterUri = "https://twitter.com/"
    static let instagramUri = "https://instagram.com/"
    static let tiktokUri = "https://tiktok.com/@"
    
}
    
