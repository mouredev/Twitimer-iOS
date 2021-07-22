//
//  SearchQueryRowView.swift
//  Twitimer
//
//  Created by Brais Moure on 19/6/21.
//

import SwiftUI

struct SearchQueryRowView: View {
    
    // Properties
    
    let user: UserSearch
    
    // Body
    
    var body: some View {
        HStack(alignment: .center, spacing: Size.none.rawValue) {
            
            HStack(alignment: .center, spacing: Size.medium.rawValue) {
                
                if let url = user.thumbnailUrl?.url {
                    UserAvatarView(url: url, user: user.broadcasterLogin ?? "", size: .veryBig)
                }
                
                Text(user.displayName ?? "").font(size: .button, type: .bold).lineLimit(1).foregroundColor(Color.lightColor)
                
                Spacer()
                
            }.padding(Size.medium.rawValue)
        }
        .background(Color.primaryColor)
        .cornerRadius(Size.big.rawValue)
        .shadow(radius: Size.verySmall.rawValue)
        .padding(.vertical, Size.small.rawValue)
        .listRowInsets(EdgeInsets())
        .padding(.horizontal, Size.medium.rawValue)
        .background(Color.secondaryBackgroundColor)
    }
    
}

struct SearchQueryRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchQueryRowView(user: UserSearch(id: "1", broadcasterLogin: "mouredev", displayName: "MoureDev", thumbnailUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png"))
    }
}
