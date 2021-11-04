//
//  UserViewModel.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

final class UserViewModel: ObservableObject {

    // Properties
    
    private let router: UserRouter
    private let user: User?
    private let onClose: (() -> Void)?
    
    private(set) var readOnly = false
    
    var isStreamer: Bool {
        get {
            return user?.streamer ?? Session.shared.user?.streamer ?? false
        }
    }
    
    @Published var schedule: [UserSchedule] = []
    @Published var onHolidays = false
    
    // Localization
    
    let scheduleText = "schedule".localizedKey
    let saveText = "schedule.save".localizedKey
    let saveAlertText = "user.saveschedule.alert.body".localizedKey 
    let streamerText = "user.streamer".localizedKey
    let syncAlertTitleText = "user.syncschedule.alert.title".localizedKey
    let syncAlertBodyText = "user.syncschedule.alert.body".localizedKey
    let syncInfoAlertTitleText = "user.scheduleinfo.alert.title".localizedKey
    let syncInfoAlertBodyText = "user.scheduleinfo.alert.body".localizedKey
    let okText = "accept".localizedKey
    let cancelText = "cancel".localizedKey

    // Initialization
    
    init(router: UserRouter, user: User?, onClose: (() -> Void)?) {
        self.router = router
        self.user = user
        self.onClose = onClose
        self.readOnly = user != nil
        
        self.schedule = filterSchedule(schedules: user?.schedule ?? Session.shared.user?.schedule ?? [])
        self.onHolidays = user?.settings?.onHolidays ?? Session.shared.user?.settings?.onHolidays ?? false
    }
    
    // Public
    
    func userView(isStreamer: Bool) -> UserHeaderView? {
        if let user = user ?? Session.shared.user {
            if user.login != nil {
                return router.userHeaderView(user: user, readOnly: readOnly, isStreamer: isStreamer, onClose: onClose, updateHolidays: {
                    self.onHolidays = Session.shared.user?.settings?.onHolidays ?? false
                })
            }
        }
        return nil
    }
    
    func infoHolidayView() -> InfoView {
        return router.infoHolidayView(readOnly: readOnly)
    }
    
    func infoStreamerView() -> InfoView {
        return router.infoStreamerView()
    }
    
    func emptyView() -> InfoView {
        return router.emptyView()
    }
        
    func hasUser() -> Bool {
        return (user ?? Session.shared.user) != nil
    }
    
    func save(streamer: Bool) {
        
        Util.endEditing()
        
        Session.shared.save(streamer: streamer)
    }
    
    func save() {
        
        Util.endEditing()
        
        Session.shared.save(schedule: schedule)
    }
    
    func syncSchedule() {
        
        Util.endEditing()
        
        Session.shared.syncSchedule {
            self.schedule = self.filterSchedule(schedules: Session.shared.user?.schedule ?? [])
        }
    }
    
    func firstSync() -> Bool {
        return UserDefaultsProvider.bool(key: .firstSync) ?? false
    }
    
    func enableSave() -> Bool {
        return schedule != Session.shared.user?.schedule
    }
    
    // Private
    
    private func filterSchedule(schedules: [UserSchedule]) -> [UserSchedule] {
        return schedules.filter { schedule in
            // Si estamos en modo lectura no se muestran los no habilitados o eventos puntuales pasados
            if !readOnly || (readOnly && schedule.enable && (schedule.weekDay != .custom || (schedule.weekDay == .custom && schedule.date > Date()))) {
                return true
            }
            return false
        }
    }
    
}
