//
//  ImageExtension.swift
//  Twitimer
//
//  Created by Brais Moure on 28/4/21.
//

import SwiftUI

extension Image {
    
    var template: Image {
        return renderingMode(.template)
    }
    
    func templateIcon(size: Size! = .medium) -> some View {
        return template.resizable().frame(width: size.rawValue, height: size.rawValue).aspectRatio(contentMode: .fit)
    }
    
}
