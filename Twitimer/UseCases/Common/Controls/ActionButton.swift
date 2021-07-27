//
//  ActionButton.swift
//  Twitimer
//
//  Created by Brais Moure on 27/7/21.
//

import SwiftUI

struct ActionButton: View {
    
    let image: Image
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            image.template.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Size.mediumBig.rawValue, height: Size.mediumBig.rawValue)
                .foregroundColor(.lightColor)
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(Size.small.rawValue)
        .background(Color.primaryColor)
        .clipShape(Circle())
        .shadow(color: Color.darkColor.opacity(UIConstants.kShadowOpacity), radius: Size.verySmall.rawValue)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(image: Image("calendar-add"), action: {
            print("ActionButton primary action")
        })
    }
}
