//
//  UserAvatarView.swift
//  Twitimer
//
//  Created by Brais Moure on 23/4/21.
//

import SwiftUI
import Kingfisher

struct UserAvatarView: View {
    
    let url: URL?
    let user: String
    let size: Size
    
    var body: some View {
        Group {
            KFImage.url(url)
                .placeholder({
                    Image("user").template.resizable()
                }).resizable()
        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.backgroundColor)
        .background(Color.textColor)
        .frame(width: size.rawValue, height: size.rawValue)
        .clipShape(Circle())
        .shadow(radius: Size.verySmall.rawValue)
        .onLongPressGesture(minimumDuration: 2) {
            Util.easteregg(user: user)
        }
    }
    
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatarView(url: URL(string: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png"), user: "mouredev", size: .gigant)
    }
}
