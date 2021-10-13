//
//  MainTextField.swift
//  Twitimer
//
//  Created by Brais Moure on 25/8/21.
//

import SwiftUI
import Combine

struct MainTextField: View {
    
    // Properties
    
    @Binding var title: String
    let placeholder: LocalizedStringKey
    var readOnly = false
    var enable = true
    
    private let kTextLimit = 100
    
    // Body
    
    var body: some View {
        
        if readOnly {
            HStack(spacing: Size.none.rawValue) {
                Text(title)
                    .font(size:.body)
                    .foregroundColor(.lightColor)
                    .padding(Size.small.rawValue)
                    .background(Color.secondaryColor)
                Spacer(minLength: Size.none.rawValue)
            }
        } else {
            TextField("", text: $title).onReceive(Just(title)) { _ in
                limitText(kTextLimit)
            }
            .modifier(TextFieldPlaceholderStyle(showPlaceHolder: title.isEmpty, placeholder: placeholder))
            .font(size:.body)
            .foregroundColor(.textColor)
            .accentColor(.textColor)
            .padding(Size.small.rawValue)
            .background(Color.backgroundColor)
            .clipShape(Capsule())
            .disabled(!enable)
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Functions
    
    private func limitText(_ upper: Int) {
        if title.count > upper {
            title = String(title.prefix(upper))
        }
    }
    
}

struct MainTextField_Previews: PreviewProvider {
    static var previews: some View {
        MainTextField(title: .constant(""), placeholder: "My placeholder")
    }
}
