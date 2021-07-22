//
//  MenuRouter.swift
//  Twitimer
//
//  Created by Brais Moure on 24/4/21.
//

import SwiftUI

final class MenuRouter {
    
    static func view() -> MenuView {
        
        let router = MenuRouter()
        let viewModel = MenuViewModel(router: router)
        let view = MenuView(viewModel: viewModel)

        return view
    }
    
    func onboardingView(onboarding: Binding<Bool>) -> OnboardingView {
        return OnboardingRouter.view(onboarding: onboarding)
    }
    
}
