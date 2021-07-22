//
//  CustomProgressView.swift
//  Twitimer
//
//  Created by Brais Moure on 29/4/21.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        VStack {
            Image("twitimer_icon").resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
