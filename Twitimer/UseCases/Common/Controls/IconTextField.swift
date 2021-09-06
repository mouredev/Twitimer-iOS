//
//  IconTextField.swift
//  Twitimer
//
//  Created by Brais Moure on 25/8/21.
//

import SwiftUI

struct IconTextField: View {
    
    // Properties
    
    let image: String
    @Binding var title: String
    let placeholder: LocalizedStringKey
    
    // Body
    
    var body: some View {
        HStack(spacing: Size.medium.rawValue) {
            Image(image).template.resizable().aspectRatio(contentMode: .fit)
                .foregroundColor(.textColor)
                .frame(width: Size.mediumBig.rawValue, height: Size.big.rawValue)
            MainTextField(title: $title, placeholder: placeholder)
        }
    }
}

struct IconTextField_Previews: PreviewProvider {
    static var previews: some View {
        IconTextField(image: "discord", title: .constant(""), placeholder: "My placeholder")
    }
}
