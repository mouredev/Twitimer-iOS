//
//  HomeRouter.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

final class HomeRouter {
    
    static func view() -> HomeView {
        
        let router = HomeRouter()
        let viewModel = HomeViewModel(router: router)
        let view = HomeView(viewModel: viewModel)

        return view
    }
    
    func menuView() -> MenuView {
        return MenuRouter.view()
    }
    
    func countdownView(delegate: CountdownViewModelDelegate?) -> CountdownView {
        CountdownRouter.view(delegate: delegate)
    }
    
    func searchView() -> SearchView {
        return SearchRouter.view()
    }
    
    func accountView(delegate: AccountViewModelDelegate?) -> AccountView {
        return AccountRouter.view(delegate: delegate)
    }
    
    func onboardingView(onboarding: Binding<Bool>) -> OnboardingView {
        return OnboardingRouter.view(onboarding: onboarding)
    }
        
}
