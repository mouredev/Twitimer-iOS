//
//  HomeViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

enum HomeViewTabType: Int {
    case countdown = 0
    case search = 1
    case account = 2
}

final class HomeViewModel: ObservableObject {

    // Properties
    
    private let router: HomeRouter
    private(set) var loaded = false
    
    var onboarding: Bool {
        get {
            return !(UserDefaultsProvider.bool(key: .onboarding) ?? false)
        }
    }
    
    // Publisehd
    
    @Published private(set) var loading = true
    
    // Localization
    
    let titleText = ""
    
    // Initialization
    
    init(router: HomeRouter) {
        self.router = router
        
        // Data
        data()
    }
    
    // Public
    
    func data() {
        
        // Carga de datos esenciales        
        Session.shared.fullReloadUser {
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    func onboardingView(onboarding: Binding<Bool>) -> OnboardingView {
        return router.onboardingView(onboarding: onboarding)
    }
    
    func menuView() -> MenuView {
        return router.menuView()
    }
    
    func tabView(type: HomeViewTabType, delegate: CountdownViewModelDelegate? = nil) -> AnyView {
        
        switch type {
        case .countdown:
            return AnyView(router.countdownView(delegate: delegate))
        case .search:
            return AnyView(router.searchView())
        case .account:
            return AnyView(router.accountView(delegate: self))
        }
    }

    func defaultTab() -> Int {
        loaded = true
        if Session.shared.user?.followedUsers?.isEmpty ?? true {
            return HomeViewTabType.account.rawValue
        } else if let followedUsers = Session.shared.user?.followedUsers, !followedUsers.isEmpty {
            return HomeViewTabType.countdown.rawValue
        }
        return HomeViewTabType.search.rawValue
    }

}


// MARK: AccountViewModelDelegate
extension HomeViewModel: AccountViewModelDelegate {
    
    func accountViewDidAuthenticated() {
        
        Session.shared.reloadUser {
            DispatchQueue.main.async {
                // HACK: Para forzar un repintado y una recarga de datos
                self.loading = true
                self.loading = false
            }
        }
    }   
    
}
