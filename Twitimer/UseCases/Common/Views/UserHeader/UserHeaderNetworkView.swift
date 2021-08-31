//
//  UserHeaderNetworkView.swift
//  Twitimer
//
//  Created by Brais Moure on 24/8/21.
//

import SwiftUI

struct UserHeaderNetworkView: View {
    
    let network: Network
    let id: String
    
    var body: some View {
        Button(action: {
            open(network: network, id: id)
        }) {
            Image(network.rawValue).resizable().aspectRatio(contentMode: .fit).frame(width: Size.mediumHalfBig.rawValue, height: Size.mediumHalfBig.rawValue)
        }
    }
        
    // Private
    
    private func open(network: Network, id: String) {
        
        var url = ""
        let networkId = id.removeSocialInvalidCharacters()
        
        switch network {
        case .discord:
            url = "\(Constants.discordUri)\(networkId)"
        case .youtube:
            url = "\(Constants.youtubeUri)\(networkId)"
        case .twitter:
            url = "\(Constants.twitterUri)\(networkId)"
        case .instagram:
            url = "\(Constants.instagramUri)\(networkId)"
        case .tiktok:
            url = "\(Constants.tiktokUri)\(networkId)"
        case .github, .twitch:
            // No soportadas
            break
        }
        
        if let url = URL(string: url) {
            Util.openBrowser(url: url)
        }
    }
    
}

struct UserHeaderNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        UserHeaderNetworkView(network: .tiktok, id: "mouredev")
    }
}
