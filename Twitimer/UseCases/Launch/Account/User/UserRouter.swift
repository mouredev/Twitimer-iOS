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
        
    func userHeaderView(user: User, readOnly: Bool, isStreamer: Bool, onClose: (() -> Void)?) -> UserHeaderView {
        return UserHeaderView(profileImageUrl: user.profileImageUrl, login: user.login, displayName: user.displayName, broadcasterType: user.broadcasterType, settings: user.settings, isStreamer: isStreamer, readOnly: readOnly, onClose: onClose)
    }
    
    func infoView() -> InfoView {
        return InfoRouter.view(type: .streamer)
    }
    
    func emptyView() -> InfoView {
        return InfoRouter.view(type: .schedule)
    }
    
}
