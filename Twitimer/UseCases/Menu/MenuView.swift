//
//  MenuView.swift
//  Twitimer
//
//  Created by Brais Moure on 24/4/21.
//

import SwiftUI

struct MenuView: View {
    
    // Properties
    
    @ObservedObject var viewModel: MenuViewModel
    @State var onboarding = false
    
    // Body
    
    var body: some View {
        Group {
            if onboarding {
                viewModel.onboardingView(onboarding: $onboarding)
            } else {
                VStack(spacing: .none) {
                    ScrollView {
                        VStack(spacing: Size.medium.rawValue) {
                            HStack {
                                Image("twitimer_logo").resizable().aspectRatio(contentMode: .fit).frame(height: Size.veryBig.rawValue)
                                Text(viewModel.byText).font(size: .body, type: .light).foregroundColor(.lightColor).multilineTextAlignment(.leading)
                                
                                ZStack(alignment: .topTrailing) {
                                    Button(action: {
                                        viewModel.open(network: .twitch)
                                    }) {
                                        Image("mouredev").resizable().aspectRatio(contentMode: .fit).frame(height: Size.veryBig.rawValue)
                                    }.padding(.trailing, Size.small.rawValue)
                                    Image("twitch").resizable().aspectRatio(contentMode: .fit).frame(height: Size.medium.rawValue)
                                }
                            }.padding(Size.medium.rawValue)
                            Text(viewModel.infoText).font(size: .caption, type: .light).foregroundColor(.lightColor).multilineTextAlignment(.leading)
                            
                            HStack(spacing: Size.medium.rawValue) {
                                
                                ForEach(Network.allCases, id: \.self) { network in
                                    Button(action: {
                                        viewModel.open(network: network)
                                    }) {
                                        Image(network.rawValue).resizable().aspectRatio(contentMode: .fit).frame(width: Size.mediumBig.rawValue, height: Size.mediumBig.rawValue)
                                    }
                                }
                                Spacer()
                            }
                            
                            Spacer()
                            
                        }.padding(EdgeInsets(top: Size.medium.rawValue, leading: Size.medium.rawValue, bottom: Size.none.rawValue, trailing: Size.medium.rawValue))
                    }.background(Color.primaryColor)
                    
                    // Footer
                    
                    VStack(spacing: Size.medium.rawValue) {
                        
                        Divider()
                        
                        NavigationButton(text: viewModel.siteText) {
                            viewModel.openSite()
                        }
                        
                        NavigationButton(text: viewModel.onboardingText) {
                            onboarding.toggle()
                        }
                        
                        HStack {
                            Text(viewModel.versionText).font(size: .caption, type: .light).foregroundColor(.textColor)
                            Spacer()
                        }
                    }
                    .padding(Size.medium.rawValue)
                    .background(Color.backgroundColor)
                    //.shadow(radius: Size.verySmall.rawValue)
                    
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuRouter.view()
        MenuRouter.view().preferredColorScheme(.dark)
    }
}
