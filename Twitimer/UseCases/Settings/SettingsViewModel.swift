//
//  SettingsViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 25/8/21.
//

import SwiftUI

protocol SettingsDelegate {
    
    func closeSession()
    
    func updated(settings: UserSettings)
    
}

final class SettingsViewModel: ObservableObject {
    
    // Properties
    
    private let router: SettingsRouter
    
    @Published var settings: UserSettings
    let streamer = Session.shared.user?.streamer ?? false
    
    private let delegate: SettingsDelegate?

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
    let deleteTitleText = "settings.deleteaccount.title".localizedKey
    let deleteButtonText = "settings.deleteaccount.button".localizedKey
    let deleteAlertText = "settings.deleteaccount.alert".localizedKey
    let okText = "accept".localizedKey
    let cancelText = "cancel".localizedKey
    
    // Initialization
    
    init(router: SettingsRouter, delegate: SettingsDelegate?) {
        self.router = router
        self.delegate = delegate
        
        self.settings = Session.shared.user?.settings ?? UserSettings()
    }
    
    func infoView() -> InfoView {
        return router.infoView()
    }
    
    func close() {
        
        Util.endEditing()
        
        Session.shared.revoke {
            self.delegate?.closeSession()
        }
    }
    
    func save() {
        
        Util.endEditing()
        
        Session.shared.save(settings: settings)
        
        // HACK: Para forzar la recarga de la vista
        settings = Session.shared.user?.settings ?? UserSettings()
        
        self.delegate?.updated(settings: settings)
    }
    
    func enableSave() -> Bool {
        return settings != Session.shared.user?.settings
    }
    
    func delete() {
        
        Util.endEditing()
        
        Session.shared.delete {
            self.delegate?.closeSession()
        }
    }
    
}
