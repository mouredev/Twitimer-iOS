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
            Image("twitch").resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Size.mediumHalfBig.rawValue, height: Size.mediumHalfBig.rawValue).colorMultiply(.lightColor)
        }).buttonStyle(BorderlessButtonStyle())
        .padding(.horizontal, Size.small.rawValue)
        .padding(.vertical, Size.small.rawValue)
        .background((darkBackground ?? false) ? Color.primaryColor : Color.secondaryColor)
        .frame(width: Size.big.rawValue, height: Size.big.rawValue)
        .clipShape(Circle())
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
