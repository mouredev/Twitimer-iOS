//
//  ViewExtension.swift
//  Twitimer
//
//  Created by Brais Moure on 21/4/21.
//

import SwiftUI

extension View {

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
        
    func enable(_ enable: Bool) -> some View {
        return opacity(enable ? 1 : UIConstants.kShadowOpacity).disabled(!enable)
    }
    
    // Brujería de la buena
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
    
    // MARK: iOS 15
    
    func hideTableSeparator() -> AnyView {
        if #available(iOS 15.0, *) {
            return AnyView(self.listRowSeparator(.hidden).listRowInsets(EdgeInsets()))
        }
        return AnyView(self.listRowInsets(EdgeInsets()))
    }
    
}

private struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
