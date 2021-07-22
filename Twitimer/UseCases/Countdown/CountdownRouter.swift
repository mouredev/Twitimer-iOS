//
//  CountdownRouter.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import Foundation

final class CountdownRouter {
    
    static func view(delegate: CountdownViewModelDelegate?) -> CountdownView {
        
        let router = CountdownRouter()
        let viewModel = CountdownViewModel(router: router, delegate: delegate)
        let view = CountdownView(viewModel: viewModel)

        return view
    }
        
    func infoView(action: @escaping () -> Void) -> InfoView {
        return InfoRouter.view(type: .countdown, action: action)
    }
        
}
