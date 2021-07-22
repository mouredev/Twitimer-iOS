//
//  AccountRouter.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

final class AccountRouter {
    
    static func view(delegate: AccountViewModelDelegate?) -> AccountView {
        
        let router = AccountRouter()
        let viewModel = AccountViewModel(router: router, delegate: delegate)
        let view = AccountView(viewModel: viewModel)

        return view
    }
    
    func infoView(action: @escaping () -> Void) -> InfoView {
        return InfoRouter.view(type: .auth, action: action)
    }
    
    func authenticatedView(onClose: @escaping () -> Void) -> UserView {
        return UserRouter.view(onClose: onClose)
    }
    
    func authView(url: URL, selected: @escaping (URL) -> Void, loading: @escaping (Bool) -> Void) -> WebView {
        return WebView(url: url, selected: selected, loading: loading)
    }
        
}
