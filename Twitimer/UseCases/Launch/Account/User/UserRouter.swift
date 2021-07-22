//
//  UserRouter.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import Foundation

final class UserRouter {
    
    static func view(onClose: @escaping () -> Void) -> UserView {
        return view(user: nil, onClose: onClose)
    }
    
    static func readOnlyView(user: User) -> UserView {
        return view(user: user, onClose: nil)
    }
    
    private static func view(user: User?, onClose: (() -> Void)?) -> UserView {
        
        let router = UserRouter()
        let viewModel = UserViewModel(router: router, user: user, onClose: onClose)
        let view = UserView(viewModel: viewModel)

        return view
    }
        
    func userHeaderView(user: User) -> UserHeaderView {
        return UserHeaderView(user: user)
    }
    
    func infoView() -> InfoView {
        return InfoRouter.view(type: .streamer)
    }
    
    func emptyView() -> InfoView {
        return InfoRouter.view(type: .schedule)
    }
    
}
