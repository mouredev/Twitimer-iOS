//
//  OnboardingView.swift
//  Twitimer
//
//  Created by Brais Moure on 16/6/21.
//

import SwiftUI

struct OnboardingView: View {
    
    // Properties
    
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var onboarding: Bool
    @State private var selection = 0
    
    // Body
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                
                viewModel.onboardingTabView(selection: $selection)
                
                HStack(spacing: Size.medium.rawValue) {
                    MainButton(text: viewModel.previousText, action: {
                        buttonAction(type: .secondary)
                    }, type: .secondary).if(selection == 0) { $0.hidden() }
                    
                    MainButton(text: selection == viewModel.pages - 1 ? viewModel.understoodText : viewModel.nextText, action: {
                        buttonAction(type: .primary)
                    }, type: .primary)
                    
                }.padding(Size.medium.rawValue)
                .shadow(radius: Size.verySmall.rawValue)
                
            }
        }.transition(.move(edge: .bottom))
    }
    
    // Private
    
    private func buttonAction(type: MainButtonType) {
        withAnimation {
            if type == .primary {
                if selection == viewModel.pages - 1 {
                    // Finish
                    Util.requestPushAuthorization(application: UIApplication.shared)
                    UserDefaultsProvider.set(key: .onboarding, value: true)
                    withAnimation {
                        onboarding.toggle()
                    }                    
                } else {
                    selection += 1
                }
            } else if type == .secondary {
                selection -= 1
            }
        }
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRouter.view(onboarding: .constant(true))
        OnboardingRouter.view(onboarding: .constant(true)).preferredColorScheme(.dark)
    }
}
