//
//  OnboardingTabView.swift
//  Twitimer
//
//  Created by Brais Moure on 16/6/21.
//

import SwiftUI

struct OnboardingTabView: View {
    
    // Properties
    
    let data: [Onboarding]
    @Binding var selection: Int
    
    // Body
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(data, id: \.id) { page in
                OnboardingPageView(data: page)
            }
        }.tabViewStyle(PageTabViewStyle()).accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}

struct OnboardingTabView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTabView(data: [Onboarding(id: 0, image: "twitimer_icon", title: "Title text 1", body: "Body text 1"), Onboarding(id: 1, image: "twitimer_icon", title: "Title text 2", body: "Body text 2")], selection: .constant(0))
    }
}
