//
//  SettingsView.swift
//  Twitimer
//
//  Created by Brais Moure on 25/8/21.
//

import SwiftUI

struct SettingsView: View {
    
    // Properties
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var showCloseSessionAlert = false
    
    // Localization
    
    // Body
    
    var body: some View {
        
        VStack(spacing: Size.none.rawValue) {
            
            VStack(alignment: .leading, spacing: Size.none.rawValue) {
                
                if viewModel.streamer {
                    
                    VStack(alignment: .leading, spacing: Size.small.rawValue) {
                        
                        Text(viewModel.socialMediaText).font(size: .head).foregroundColor(.textColor).padding(.bottom, Size.medium.rawValue)
                        
                        IconTextField(image: "discord", title: $viewModel.settings.discord, placeholder: viewModel.discordPlaceholder)
                        
                        IconTextField(image: "youtube", title: $viewModel.settings.youtube, placeholder: viewModel.youtubePlaceholder)
                        
                        IconTextField(image: "twitter", title: $viewModel.settings.twitter, placeholder: viewModel.twitterPlaceholder)
                        
                        IconTextField(image: "instagram", title: $viewModel.settings.instagram, placeholder: viewModel.instagramPlaceholder)
                        
                        IconTextField(image: "tiktok", title: $viewModel.settings.tiktok, placeholder: viewModel.tiktokPlaceholder)
                        
                        Spacer()
                    }.padding(EdgeInsets(top: Size.big.rawValue, leading: Size.medium.rawValue, bottom: Size.medium.rawValue, trailing: Size.medium.rawValue))
                    
                } else {
                
                    // Info
                    
                    viewModel.infoView()
                }
                
            }.background(Color.secondaryBackgroundColor)
            .cornerRadius(Size.big.rawValue, corners: [.topRight, .topLeft])
            .shadow(radius: Size.verySmall.rawValue)
            
            // Buttons
            
            HStack(spacing: Size.medium.rawValue) {
                
                MainButton(text: viewModel.closeText, action: {
                    showCloseSessionAlert.toggle()
                }, type: .secondary)
                .alert(isPresented: $showCloseSessionAlert) { () -> Alert in
                    Alert(title: Text(viewModel.closeText), message: Text(viewModel.closeAlertText), primaryButton: .default(Text(viewModel.okText), action: {
                        
                        viewModel.close()
                        
                    }), secondaryButton: .cancel(Text(viewModel.cancelText)))
                }
                
                if viewModel.streamer {
                
                    MainButton(text: viewModel.saveText, action: {
                        viewModel.save()
                    }, type: .primary).enable(viewModel.enableSave())
                }
                
            }.padding(Size.medium.rawValue)
            .background(Color.backgroundColor)
            .shadow(radius: Size.verySmall.rawValue)
            
        }
        .background(Color.primaryColor)
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarTitle("", displayMode: .inline)
        .ignoresSafeArea(.keyboard, edges: .top)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRouter.view(delegate: nil)
    }
}
