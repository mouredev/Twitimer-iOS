//
//  UserHeaderView.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import SwiftUI

struct UserHeaderView: View {
    
    // Properties
    
    let profileImageUrl: String?
    let login: String?
    let displayName: String?
    let broadcasterType: BroadcasterType?
    let settings: UserSettings?
    let isStreamer: Bool
    var small: Bool = false
    let readOnly: Bool
    let onClose: (() -> Void)?
    
    // Body
    
    var body: some View {
        HStack(alignment: small ? .center : .top, spacing: Size.medium.rawValue) {
            
            if let url = profileImageUrl?.url {
                UserAvatarView(url: url, user: login ?? "", size: small ? .veryBig : .gigant, settings: !readOnly, onClose: onClose)
            }
            
            VStack(alignment: .leading) {
                if small {
                    HStack(spacing: Size.none.rawValue) {
                        Text(displayName ?? "").font(size: .button, type: .bold).lineLimit(1)
                        Spacer()
                        ChannelButton(login: login, darkBackground: true)
                    }
                } else {
                    HStack(alignment: .top) {
                        Text(displayName ?? "").font(size: .title)
                        Spacer()
                        if let broadcasterType = broadcasterType, !broadcasterType.rawValue.isEmpty {
                            UserBroadcasterTypeView(type: broadcasterType)
                        }
                    }
                    Text("@\(login ?? "")").font(size: .body, type: .light)
                    
                    HStack(spacing: Size.none.rawValue) {
                        
                        HStack(spacing: Size.smallMedium.rawValue) {
                            
                            if isStreamer {
                                
                                if let discord = settings?.discord, !discord.isEmpty {
                                    UserHeaderNetworkView(network: .discord, id: discord)
                                }
                                
                                if let youtube = settings?.youtube, !youtube.isEmpty {
                                    UserHeaderNetworkView(network: .youtube, id: youtube)
                                }
                                
                                if let twitter = settings?.twitter, !twitter.isEmpty {
                                    UserHeaderNetworkView(network: .twitter, id: twitter)
                                }
                                
                                if let instagram = settings?.instagram, !instagram.isEmpty {
                                    UserHeaderNetworkView(network: .instagram, id: instagram)
                                }
                                
                                if let tiktok = settings?.tiktok, !tiktok.isEmpty {
                                    UserHeaderNetworkView(network: .tiktok, id: tiktok)
                                }
                                
                            }
                        }
                        
                        Spacer(minLength: Size.none.rawValue)
                        ChannelButton(login: login, darkBackground: false)
                    }
                }
            }.foregroundColor(Color.lightColor)
            
        }.padding(Size.medium.rawValue)
    }
    
}

struct UserHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UserHeaderView(profileImageUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png", login: "mouredev", displayName: "MoureDev", broadcasterType: .partner, settings: UserSettings(discord: "", youtube: "", twitter: "mouredev", instagram: "mouredev", tiktok: "mouredev"), isStreamer: true, small: false, readOnly: false, onClose: {
            print("onClose")
        }).background(Color.primaryColor)
    }
}
