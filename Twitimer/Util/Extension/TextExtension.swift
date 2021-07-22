//
//  TextExtension.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import SwiftUI

enum FontSize: CGFloat {
    case title = 24
    case subtitle = 22
    case head = 18
    case subhead = 16
    case body = 15
    case button = 14
    case caption = 12
}

enum FontType: String {
    case light = "Inter-Light"
    case regular = "Inter-Regular"
    case bold = "Inter-Bold"
}

extension View {
    
    func font(size: FontSize, type: FontType? = nil) -> some View {
        
        var fontType = type
        
        if type == nil {
            switch size {
            case .title, .head, .button, .caption:
                fontType = .bold
            case .subtitle, .subhead:
                fontType = .light
            case .body:
                fontType = .regular
            }
        }
        
        return self.font(Font.custom(fontType!.rawValue, size: size.rawValue))
    }
    
}
