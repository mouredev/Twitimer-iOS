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
    let settings: Bool
    let onClose: (() -> Void)?
    
    @State var settingsView = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
            if settings {
                Button(action: {
                    settingsView = true
                }, label: {
                    Image("settings").template.resizable()
                        .padding(Size.small.rawValue)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.lightColor)
                    
                })
                .background(Color.primaryColor)
                .frame(width: Size.bigMedium.rawValue, height: Size.bigMedium.rawValue)
                .clipShape(Circle())
                .shadow(radius: Size.verySmall.rawValue)
            }
        }.sheet(isPresented: $settingsView) {
            NavigationView {
                SettingsRouter.view {
                    settingsView = false
                    onClose?()
                }.navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    settingsView = false
                }) {
                    Image("cross").template
                })
            }
        }
    }
    
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatarView(url: URL(string: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png"), user: "mouredev", size: .gigant, settings: true, onClose: {
            print("onClose")
        })
    }
}
