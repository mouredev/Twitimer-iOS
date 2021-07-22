//
//  OnboardingRouter.swift
//  Twitimer
//
//  Created by Brais Moure on 16/6/21.
//

import SwiftUI

final class OnboardingRouter {
    
    static func view(onboarding: Binding<Bool>) -> OnboardingView {
        
        let router = OnboardingRouter()
        let viewModel = OnboardingViewModel(router: router)
        let view = OnboardingView(viewModel: viewModel, onboarding: onboarding)

        return view
    }
    
    func onboardingTabView(data: [Onboarding], selection: Binding<Int>) -> OnboardingTabView {
        return OnboardingTabView.init(data: data, selection: selection)
    }
    
}
