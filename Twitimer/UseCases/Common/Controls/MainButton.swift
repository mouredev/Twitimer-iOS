//
//  MainButton.swift
//  Twitimer
//
//  Created by Brais Moure on 21/4/21.
//

import SwiftUI

enum MainButtonType {
    case primary, secondary, destroy
}

struct MainButton: View {
    
    let text: LocalizedStringKey
    let action: () -> Void
    let type: MainButtonType
    
    private let kHeight: CGFloat = 48
    
    var body: some View {
        
        switch type {
        case .primary:
            
            Button(action: action) {
                HStack {
                    Spacer()
                    Text(text).foregroundColor(.lightColor).font(size: .button)
                    Spacer()
                }
            }.frame(height: kHeight)
            .background(Color.primaryColor)
            .clipShape(Capsule())
            
        case .secondary:
            
            Button(action: action) {
                HStack {
                    Spacer()
                    Text(text).foregroundColor(.textColor).font(size: .button)
                    Spacer()
                }
            }.frame(height: kHeight)
            .background(Color.backgroundColor)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(lineWidth: Stroke.medium.rawValue).foregroundColor(.primaryColor))
            
        case .destroy:
            
            Button(action: action) {
                HStack {
                    Spacer()
                    Text(text).foregroundColor(.lightColor).font(size: .button)
                    Spacer()
                }
            }.frame(height: kHeight)
            .background(Color.liveColor)
            .clipShape(Capsule())
        }
    }
}

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Size.medium.rawValue) {
            MainButton(text: "MainButton Primary", action: {
                print("MainButton primary action")
            }, type: .primary)
            
            MainButton(text: "MainButton Secondary", action: {
                print("MainButton secondary action")
            }, type: .secondary)
            
            MainButton(text: "MainButton Destroy", action: {
                print("MainButton destroy action")
            }, type: .destroy)
        }.preferredColorScheme(.dark).padding(Size.medium.rawValue)
    }
}
