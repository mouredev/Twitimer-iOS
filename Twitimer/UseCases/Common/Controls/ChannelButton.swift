//
//  ChannelButton.swift
//  Twitimer
//
//  Created by Brais Moure on 28/4/21.
//

import SwiftUI

struct ChannelButton: View {
    
    // Properties
    
    let login: String?
    let darkBackground: Bool?
    
    // Localization
    
    private let seeChannelText = "user.seechannel".localizedKey
    
    // Body
    
    var body: some View {
        Button(action: {
            profile()
        }, label: {
            Text(seeChannelText)
                .font(size: .caption, type: .light).foregroundColor(.lightColor)
            Image("twitch").resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Size.medium.rawValue).colorMultiply(.lightColor)
        }).buttonStyle(BorderlessButtonStyle())
        .padding(.horizontal, Size.small.rawValue)
        .padding(.vertical, Size.verySmall.rawValue)
        .background((darkBackground ?? false) ? Color.primaryColor : Color.secondaryColor)
        .clipShape(Capsule())
        .shadow(color: Color.darkColor.opacity(UIConstants.kShadowOpacity), radius: Size.verySmall.rawValue)
    }
        
    // MARK: Functions
    
    private func profile() {
        if let login = login, let url = URL(string: "\(Constants.kTwitchProfileUri)\(login)") {
            Util.openBrowser(url: url)
        }
    }
}

struct ChannelButton_Previews: PreviewProvider {
    static var previews: some View {
        ChannelButton(login: "mouredev", darkBackground: true)
    }
}
