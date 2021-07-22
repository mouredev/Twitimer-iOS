//
//  UserBroadcasterTypeView.swift
//  Twitimer
//
//  Created by Brais Moure on 4/5/21.
//

import SwiftUI

struct UserBroadcasterTypeView: View {
    
    let type: BroadcasterType
    
    var body: some View {
        HStack(alignment: .center, spacing: Size.verySmall.rawValue) {
            Text(type.rawValue.capitalized)
                .font(size: .caption, type: .light)
                .foregroundColor(.darkColor)
            if type == .partner {
                Image("check-badge").templateIcon().foregroundColor(Color.darkColor)
            }
        }.frame(height: Size.medium.rawValue)
        .padding(.horizontal, Size.small.rawValue)
        .padding(.vertical, Size.verySmall.rawValue)
        .background(Color.lightColor)
        .clipShape(Capsule())
    }
}

struct UserBroadcasterTypeView_Previews: PreviewProvider {
    static var previews: some View {
        UserBroadcasterTypeView(type: .partner)
    }
}
