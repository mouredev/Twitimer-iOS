//
//  HomeView.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

struct HomeView: View {
    
    // Properties
    
    @ObservedObject var viewModel: HomeViewModel
    @State var onboarding = true
    @State var selection = 0
    @State var modalInfo = false
    
    // Body
    
    var body: some View {
        Group {
            if onboarding {
                viewModel.onboardingView(onboarding: $onboarding)
            } else {
                ZStack {
                    
                    Color.primaryColor.ignoresSafeArea()
                    
                    if viewModel.loading {
                        if !onboarding {
                            CustomProgressView()
                        }
                    } else {
                        NavigationView {
                            TabView(selection: $selection) {
                                viewModel.tabView(type: .countdown, delegate: self).tabItem {
                                    HStack {
                                        Image("calendar-clock").template
                                    }.frame(width: 10, height: 10, alignment: .center)
                                }.tag(HomeViewTabType.countdown.rawValue)
                                viewModel.tabView(type: .search).tabItem {
                                    Image("search").template
                                }.tag(HomeViewTabType.search.rawValue)
                                viewModel.tabView(type: .account).tabItem {
                                    Image("user").template
                                }.tag(HomeViewTabType.account.rawValue)
                            }
                            .navigationBarTitle(viewModel.titleText).navigationBarTitleDisplayMode(.inline).accentColor(.primaryColor)
                            .toolbar {
                                Button(action: {
                                    modalInfo = true
                                }) {
                                    Image("navigation-menu-horizontal").template.colorMultiply(.lightColor)
                                }
                            }
                            .onAppear() {
                                if !viewModel.loaded {
                                    selection = viewModel.defaultTab()
                                }
                            }
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    Image("twitimer_logo").resizable().aspectRatio(contentMode: .fit).frame(height: Size.mediumBig.rawValue)
                                }
                            }
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .opacity(viewModel.loading ? 0 : 1)
                        .sheet(isPresented: $modalInfo) {
                            NavigationView {
                                viewModel.menuView()
                                    .navigationBarTitle(Text(viewModel.titleText), displayMode: .inline)
                                    .navigationBarItems(leading: Button(action: {
                                        modalInfo = false
                                    }) {
                                        Image("cross").template
                                    })
                            }
                        }
                    }
                }
            }
        }.background(Color.backgroundColor)
        .onAppear() {
            onboarding = viewModel.onboarding
        }
    }
}


// MARK: CountdownViewModelDelegate
extension HomeView: CountdownViewModelDelegate {
    
    func countdownViewDidShowSearch() {
        selection = HomeViewTabType.search.rawValue
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeRouter.view()
    }
}
