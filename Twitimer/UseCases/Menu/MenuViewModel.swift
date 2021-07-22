//
//  MenuViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 24/4/21.
//

import SwiftUI

enum Network: String, CaseIterable {
    
    case twitch, discord, youtube, twitter, instagram, github
    
    var uri: String {
        switch self {
        case .twitch:
            return Constants.kTwitchMoureDevUri
        case .discord:
            return Constants.kDiscordMoureDevUri
        case .youtube:
            return Constants.kYouTubeMoureDevUri
        case .twitter:
            return Constants.kTwitterMoureDevUri
        case .instagram:
            return Constants.kInstagramMoureDevUri
        case .github:
            return Constants.kGitHubMoureDevUri
        }
    }
    
}

final class MenuViewModel: ObservableObject {

    // Properties
    
    private let router: MenuRouter
    
    let byText = "menu.by".localizedKey
    let infoText = "menu.info".localizedKey
    let siteText = "menu.site".localizedKey
    let onboardingText = "menu.onboarding".localizedKey
    var versionText: String {
        return String(format: "menu.version".localized, Util.version())
    }
    
    // Initialization
    
    init(router: MenuRouter) {
        self.router = router
    }
    
    // Public
    
    func onboardingView(onboarding: Binding<Bool>) -> OnboardingView {
        return router.onboardingView(onboarding: onboarding)
    }
    
    func open(network: Network) {
        if let url = URL(string: network.uri) {
            Util.openBrowser(url: url)
        }
    }
    
    func openSite() {
        if let url = URL(string: Constants.kTwitimerUri) {
            Util.openBrowser(url: url)
        }
    }
    
}
