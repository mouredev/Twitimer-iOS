//
//  AccountViewViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

protocol AccountViewModelDelegate {
    
    func accountViewDidAuthenticated()
    
}

final class AccountViewModel: ObservableObject {

    // Properties
    
    private let router: AccountRouter
    private let delegate: AccountViewModelDelegate?
    
    private let kTwitchService = TwitchService.shared
        
    private var authorizeURL: URL {
        return kTwitchService.authorizeURL
    }
    
    // Publisehd

    @Published private(set) var authenticated = false
    @Published private(set) var info = true
    @Published private(set) var loading = false
    
    // Initialization
    
    init(router: AccountRouter, delegate: AccountViewModelDelegate?) {
        self.router = router
        self.delegate = delegate
        load()
    }
    
    // Public
    
    func load() {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.authenticated = Session.shared.user?.login != nil
                self.info = !self.authenticated
            }
        }
    }
    
    func selected(url: URL) {

        if url.host?.contains("localhost") ?? false {
            
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            let authCodeItem = components?.queryItems?.first(where: { (item) -> Bool in
                return item.name == "code"
            })
            if let authorizationCode = authCodeItem?.value {
                authenticate(authorizationCode: authorizationCode)
            }
        }
    }
    
    func infoView() -> InfoView {
        return router.infoView {
            self.info = false
        }
    }
    
    func authenticatedView() -> UserView {
        return router.authenticatedView(onClose: {
            self.load()
        })
    }
    
    func authView() -> WebView {
        
        return router.authView(url: authorizeURL) { (url) in
            self.selected(url: url)
        } loading: { (loading) in
            self.loading = loading
        }
    }
    
    // Private
    
    private func authenticate(authorizationCode: String) {
        
        Session.shared.authenticate(authorizationCode: authorizationCode) {
            self.load()
            self.delegate?.accountViewDidAuthenticated()
        } failure: { (error) in
            self.load()
        }
    }
    
}
