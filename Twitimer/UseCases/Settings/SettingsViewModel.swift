//
//  SettingsViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 25/8/21.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    // Properties
    
    private let router: SettingsRouter
    
    @Published var settings: UserSettings
    let streamer = Session.shared.user?.streamer ?? false
    
    private let onClose: (() -> Void)?

    // Localization
    
    let socialMediaText = "settings.socialmedia".localizedKey
    let discordPlaceholder = "settings.discord.placeholder".localizedKey
    let youtubePlaceholder = "settings.youtube.placeholder".localizedKey
    let twitterPlaceholder = "settings.twitter.placeholder".localizedKey
    let instagramPlaceholder = "settings.instagram.placeholder".localizedKey
    let tiktokPlaceholder = "settings.tiktok.placeholder".localizedKey
    let closeText = "user.closesession".localizedKey
    let closeAlertText = "user.closesession.alert.body".localizedKey
    let saveText = "settings.savesettings".localizedKey
    let okText = "accept".localizedKey
    let cancelText = "cancel".localizedKey
    
    // Initialization
    
    init(router: SettingsRouter, onClose: (() -> Void)?) {
        self.router = router
        self.onClose = onClose  
        
        self.settings = Session.shared.user?.settings ?? UserSettings()
    }
    
    func infoView() -> InfoView {
        return router.infoView()
    }
    
    func close() {
        
        Util.endEditing()
        
        Session.shared.revoke {
            self.onClose?()
        }
    }
    
    func save() {
        
        Util.endEditing()
        
        Session.shared.save(settings: settings)
        
        // HACK: Para forzar la recarga de la vista
        settings = Session.shared.user?.settings ?? UserSettings()
    }
    
    func enableSave() -> Bool {
        return settings != Session.shared.user?.settings
    }
    
}
