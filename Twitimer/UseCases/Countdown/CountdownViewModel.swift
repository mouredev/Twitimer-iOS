//
//  CountdownViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import Foundation

protocol CountdownViewModelDelegate {
    
    func countdownViewDidShowSearch()
    
}

final class CountdownViewModel: ObservableObject {
    
    // Properties
    
    private let router: CountdownRouter
    private let delegate: CountdownViewModelDelegate?
    
    // Localization
    
    let updateText = "countdown.reload".localizedKey
    let upcomingText = "countdown.upcoming".localizedKey
    
    // Publisehd
    
    @Published private(set) var loading = false
    @Published private(set) var streamings = Session.shared.sortedStreamings() ?? []
    
    // Initialization
    
    init(router: CountdownRouter, delegate: CountdownViewModelDelegate?) {
        self.router = router
        self.delegate = delegate
    }
    
    // Public
    
    func data() {
        Session.shared.reloadUser {
            DispatchQueue.main.async {
                self.loading = false
                self.streamings = Session.shared.sortedStreamings() ?? []
            }
        }
    }
    
    func infoView() -> InfoView {
        return router.infoView {
            self.delegate?.countdownViewDidShowSearch()
        }
    }
    
    func reload() {
        loading = true
        Session.shared.reloadStreamers {
            self.data()
        }
    }
    
}
