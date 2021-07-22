//
//  SearchRouter.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import Foundation

final class SearchRouter {
    
    static func view() -> SearchView {
        
        let router = SearchRouter()
        let viewModel = SearchViewModel(router: router)
        let view = SearchView(viewModel: viewModel)

        return view
    }
    
    func infoView(type: InfoViewType) -> InfoView {
        return InfoRouter.view(type: type)
    }
        
}
