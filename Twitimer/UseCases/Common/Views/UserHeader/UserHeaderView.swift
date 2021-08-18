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
    var small: Bool = false
    
    // Body
    
    var body: some View {
        HStack(alignment: small ? .center : .top, spacing: Size.medium.rawValue) {
            
            if let url = profileImageUrl?.url {
                UserAvatarView(url: url, user: login ?? "", size: small ? .veryBig : .gigant)
            }
            
            VStack(alignment: .leading) {
                if small {
                    HStack(spacing: Size.none.rawValue) {
                        Text(displayName ?? "").font(size: .button, type: .bold).lineLimit(1)
                        Spacer()
                        ChannelButton(login: login, darkBackground: true)
                    }
                } else {
                    Text(displayName ?? "").font(size: .title)
                    Text("@\(login ?? "")").font(size: .body, type: .light)
                    
                    HStack {
                        if let broadcasterType = broadcasterType, !broadcasterType.rawValue.isEmpty {
                            UserBroadcasterTypeView(type: broadcasterType)
                        }
                        Spacer()
                        ChannelButton(login: login, darkBackground: false)
                    }
                }
            }.foregroundColor(Color.lightColor)
            
        }.padding(Size.medium.rawValue)
    }
    
}

struct UserHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UserHeaderView(profileImageUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png", login: "mouredev", displayName: "MoureDev", broadcasterType: .partner, small: true).background(Color.primaryColor)
    }
}
