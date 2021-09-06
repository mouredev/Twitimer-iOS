//
//  SearchViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import Foundation

final class SearchViewModel: ObservableObject {

    // Properties
    
    private let router: SearchRouter
    
    private var lastSearchedUser: String?
    private(set) var found = false
    
    // Localization
    
    let searchText = "search".localizedKey
    let cancelText = "cancel".localizedKey
    let streamersText = "search.channel".localizedKey
    let followedstreamersText = "search.followedchannels".localizedKey
    let searchPlaceholderText = "search.bar.placeholder".localizedKey
    
    // Publisehd
    
    @Published private(set) var loading = false
    @Published private(set) var users: [User] = Session.shared.streamers ?? []
    @Published private(set) var streamersCount: Int = Session.shared.streamers?.count ?? 0
    @Published private(set) var search: [UserSearch] = []
    
    // Initialization
    
    init(router: SearchRouter) {
        self.router = router
    }
    
    // Public
    
    func search(query: String) {
        
        Util.endEditing()
        
        if !query.isEmpty {
            loading = true
            TwitchService.shared.search(query: query) { search in
                self.loading = false
                self.search = search
            } failure: { _ in
                self.search(user: query)
            }
        } else {
            showStreamers()
        }
    }
    
    func search(user: String) {
        
        Util.endEditing()
        
        lastSearchedUser = user
        
        if !user.isEmpty {
            loading = true
            FirebaseRDBService.shared.search(query: user) { (users) in
                Session.shared.reloadUser {
                    DispatchQueue.main.async {
                        self.loading = false
                        self.search = []
                        self.found = !user.isEmpty
                        self.users = users ?? []
                    }
                }
            } failure: { (error) in
                Session.shared.reloadUser {
                    DispatchQueue.main.async {
                        self.loading = false
                        self.search = []
                        self.found = false
                        self.users = []
                    }
                }
            }
        } else {
            Session.shared.reloadUser {
                DispatchQueue.main.async {
                    self.showStreamers()
                }
            }
        }
    }
    
    func infoSearchView() -> InfoView {
        return InfoRouter.view(type: .search)
    }
    
    func infoChannelView() -> InfoView {
        return InfoRouter.view(type: .channel, extra: lastSearchedUser)
    }
    
    func editing() {
        search = []
        found = false
        users = []
    }

    func cancel() {
        found = false
        search(query: "")
    }
    
    func updateCount() {
        Util.endEditing()
        streamersCount = Session.shared.user?.followedUsers?.count ?? 0
        showStreamers()
    }
    
    // Private
    
    private func showStreamers() {
        loading = false
        search = []
        found = false
        users = Session.shared.streamers ?? []
        streamersCount = users.count
    }
    
}
