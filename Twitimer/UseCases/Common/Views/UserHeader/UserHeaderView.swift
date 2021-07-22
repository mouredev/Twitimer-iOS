//
//  UserHeaderView.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import SwiftUI

struct UserHeaderView: View {

    // Properties
    
    let user: User
    var small: Bool = false
    
    // Body
    
    var body: some View {
        HStack(alignment: small ? .center : .top, spacing: Size.medium.rawValue) {
            
            if let url = user.profileImageUrl?.url {            
                UserAvatarView(url: url, user: user.login ?? "", size: small ? .veryBig : .gigant)
            }
            
            VStack(alignment: .leading) {
                if small {
                    HStack(spacing: Size.none.rawValue) {
                        Text(user.displayName ?? "").font(size: .button, type: .bold).lineLimit(1)
                        Spacer()
                        ChannelButton(login: user.login, darkBackground: true)
                    }
                } else {
                    Text(user.displayName ?? "").font(size: .title)
                    Text("@\(user.login ?? "")").font(size: .body, type: .light)
                    
                    HStack {
                        if let broadcasterType = user.broadcasterType, !broadcasterType.rawValue.isEmpty {
                            UserBroadcasterTypeView(type: broadcasterType)
                        }
                        Spacer()
                        ChannelButton(login: user.login, darkBackground: false)
                    }
                }
            }.foregroundColor(Color.lightColor)
            
        }.padding(Size.medium.rawValue)
    }
    
}

struct UserHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UserHeaderView(user: User(id: "1", login: "mouredev", displayName: "MoureDev", broadcasterType: .partner, descr: nil, profileImageUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png", offlineImageUrl: nil, schedule: nil), small: true).background(Color.primaryColor)
    }
}
