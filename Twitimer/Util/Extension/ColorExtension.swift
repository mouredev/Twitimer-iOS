//
//  ColorExtension.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

extension Color {
    
    // Colors
    
    static let primaryColor = Color("AccentColor")
    static let secondaryColor = Color("SecondaryColor")
    static let lightColor = Color("LightColor")
    static let darkColor = Color("DarkColor")
    static let textColor = Color("TextColor")
    static let backgroundColor = Color("BackgroundColor")
    static let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
    static let liveColor = Color("LiveColor")
    
    // Util
    
    var uiColor: UIColor {
        return UIColor(self)
    }
    
}
