//
//  AccountView.swift
//  Twitimer
//
//  Created by Brais Moure on 19/4/21.
//

import SwiftUI

struct AccountView: View {
    
    // Properties
    
    @ObservedObject var viewModel: AccountViewModel
    
    // Body
    
    var body: some View {
        VStack {
            if viewModel.authenticated {
                viewModel.authenticatedView()
            } else if viewModel.info {
                viewModel.infoView().background(Color.backgroundColor)
            } else {
                ZStack {
                    viewModel.authView()
                    if viewModel.loading {
                        CustomProgressView()
                    }
                }
            }
        }
    }
    
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountRouter.view(delegate: nil)
    }
}
