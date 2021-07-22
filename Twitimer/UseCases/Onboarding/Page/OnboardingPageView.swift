//
//  OnboardingPageView.swift
//  Twitimer
//
//  Created by Brais Moure on 16/6/21.
//

import SwiftUI

struct OnboardingPageView: View {
    
    // Properties
    
    let data: Onboarding
    
    // Body
    
    var body: some View {
        VStack(spacing: Size.medium.rawValue) {
            Image(data.image).resizable().aspectRatio(contentMode: .fit).frame(width: Size.gigant.rawValue * 2, height: Size.gigant.rawValue * 2).foregroundColor(.textColor)
            Text(data.title.localizedKey).font(size: .subtitle, type: .bold).foregroundColor(.lightColor).multilineTextAlignment(.center)
            Text(data.body.localizedKey).font(size: .subhead, type: .light).foregroundColor(.lightColor).multilineTextAlignment(.leading)
        }.padding(Size.medium.rawValue)
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(data: Onboarding(id: 0, image: "twitimer_icon", title: "Title text", body: "Body text"))
    }
}
