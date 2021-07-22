//
//  OnboardingViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 16/6/21.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {

    // Properties
    
    private let router: OnboardingRouter
    
    private let data = [Onboarding(id: 0, image: "twitimer_icon", title: "onboarding.page0.title", body: "onboarding.page0.body"),
                                      Onboarding(id: 1, image: "radio_microphone", title: "onboarding.page1.title", body: "onboarding.page1.body"),
                                      Onboarding(id: 2, image: "examine", title: "onboarding.page2.title", body: "onboarding.page2.body"),
                                      Onboarding(id: 3, image: "timer", title: "onboarding.page3.title", body: "onboarding.page3.body"),
                                      Onboarding(id: 4, image: "risk_assesment", title: "onboarding.page4.title", body: "onboarding.page4.body")]
    
    var pages: Int {
        get {
            return data.count
        }
    }
    
    // Localization
    
    let understoodText = "understood".localizedKey
    let previousText = "previous".localizedKey
    let nextText = "next".localizedKey
    
    // Initialization
    
    init(router: OnboardingRouter) {
        self.router = router
    }
    
    // Public
    
    func onboardingTabView(selection: Binding<Int>) -> OnboardingTabView {
        return router.onboardingTabView(data: data, selection: selection)
    }
    
}
