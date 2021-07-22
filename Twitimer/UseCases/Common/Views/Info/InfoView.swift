//
//  InfoView.swift
//  Twitimer
//
//  Created by Brais Moure on 23/4/21.
//

import SwiftUI

struct InfoView: View {
    
    // Properties
    
    @ObservedObject var viewModel: InfoViewModel
    
    // Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: Size.medium.rawValue) {
                
                Spacer(minLength: Size.medium.rawValue)
                
                Image(viewModel.image).resizable().aspectRatio(contentMode: .fit).frame(width: Size.gigant.rawValue * 1.5, height: Size.gigant.rawValue * 1.5).foregroundColor(.textColor)
                Text(viewModel.title).font(size: .subtitle, type: .bold).foregroundColor(.textColor).multilineTextAlignment(.center)
                Text(viewModel.body).font(size: .button, type: .light).foregroundColor(.textColor).multilineTextAlignment(.center)
                
                if viewModel.type == .countdown || viewModel.type == .auth {
                    
                    MainButton(text: viewModel.advice(number: 1), action: {
                        viewModel.infoAction()
                    }, type: .primary).shadow(radius: Size.verySmall.rawValue)
                    
                } else if viewModel.type == .channel {
                    
                    HStack(spacing: Size.big.rawValue) {
                        Button(action: {
                            viewModel.tweet()
                        }) {                            Image("twitter").template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.big.rawValue, height: Size.big.rawValue).foregroundColor(.textColor)
                        }
                        Button(action: {
                            viewModel.share()
                        }) {                            Image("share").template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.big.rawValue, height: Size.big.rawValue).foregroundColor(.textColor)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: Size.medium.rawValue) {
                    if viewModel.type == .search {
                        
                        Spacer(minLength: Size.none.rawValue)
                        HStack(spacing: Size.medium.rawValue) {
                            Image("calendar-add").template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.big.rawValue).foregroundColor(.textColor)
                            Text(viewModel.advice(number: 1)).font(size: .caption, type: .light).foregroundColor(.textColor)
                            Spacer()
                        }
                        HStack(spacing: Size.medium.rawValue) {
                            Image("calendar-remove").template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.big.rawValue).foregroundColor(.textColor)
                            Text(viewModel.advice(number: 2)).font(size: .caption, type: .light).foregroundColor(.textColor)
                            Spacer()
                        }
                        
                    } else if viewModel.type == .channel {
                                                
                        Spacer(minLength: Size.none.rawValue)
                        HStack(spacing: Size.medium.rawValue) {
                            Image("megaphone").template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.big.rawValue).foregroundColor(.textColor)
                            Text(viewModel.advice(number: 1)).font(size: .caption, type: .light).foregroundColor(.textColor)
                            Spacer()
                        }
                        
                    } else if viewModel.type == .streamer {
                        
                        Spacer(minLength: Size.none.rawValue)
                        HStack(spacing: Size.medium.rawValue) {
                            Image("calendar").template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.big.rawValue).foregroundColor(.textColor)
                            Text(viewModel.advice(number: 1)).font(size: .caption, type: .light).foregroundColor(.textColor)
                            Spacer()
                        }
                        
                    } else if viewModel.type == .schedule {
                                                
                        Spacer(minLength: Size.none.rawValue)
                        HStack(spacing: Size.medium.rawValue) {
                            Image("time-clock-circle").template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.big.rawValue).foregroundColor(.textColor)
                            Text(viewModel.advice(number: 1)).font(size: .caption, type: .light).foregroundColor(.textColor)
                            Spacer()
                        }.padding(.bottom, Size.big.rawValue)
                    }
                }
            }.padding(Size.medium.rawValue)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoRouter.view(type: .channel, extra: "Ibai")
        InfoRouter.view(type: .schedule).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
