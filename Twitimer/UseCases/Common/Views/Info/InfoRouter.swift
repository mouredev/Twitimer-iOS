//
//  InfoRouter.swift
//  Twitimer
//
//  Created by Brais Moure on 23/4/21.
//

import Foundation

final class InfoRouter {
    
    static func view(type: InfoViewType, extra: String? = nil, action: (() -> Void)? = nil) -> InfoView {
        
        if type == .channel && extra == nil {
            preconditionFailure("La información de tipo channel debe poseer un extra para el nombre de usuario")
        }
        
        let router = InfoRouter()
        let viewModel = InfoViewModel(router: router, type: type, extra: extra, action: action)
        let view = InfoView(viewModel: viewModel)

        return view
    }
        
}
