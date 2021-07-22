//
//  TwitimerApp.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import SwiftUI

@main
struct TwitimerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeRouter.view()
        }
    }
}
