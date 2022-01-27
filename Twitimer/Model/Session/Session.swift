//
//  Session.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import Foundation
import Alamofire
import FirebaseAuth
import FirebaseMessaging

typealias SortedStreaming = (streamer: User, schedule: UserSchedule)

final class Session {
    
    // Initialization
    static let shared = Session()
        
    // Properties
    
    private(set) var token: TwitchToken?
    private(set) var user: User?
    private(set) var streamers: [User]?
    private var firebaseAuthUid: String?
    
    var authHeaders: HTTPHeaders {
        let clientID = FirebaseRCService.shared.twitchClientID ?? ""
        if let accessToken = token?.accessToken {
            return ["Client-Id": clientID, "Authorization": "Bearer \(accessToken)"]
        }
        return ["Client-Id": clientID]
    }
    
    private enum LanguageType: String {
        case es = "ES"
        case en = "EN"
    }
    
    // Life cycle
    
    init() {
        token = UserDefaultsProvider.codable(key: .token)
        user = UserDefaultsProvider.codable(key: .authUser)
        let users: Users? = UserDefaultsProvider.codable(key: .streamers)
        streamers = users?.data
        firebaseAuthUid = UserDefaultsProvider.string(key: .firebaseAuthUid)
        
        defaultUser()
    }

    // Public
    
    func authenticate(authorizationCode: String, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        TwitchService.shared.token(authorizationCode: authorizationCode, success: { (token) in
            
            self.save(token: token)
            
            TwitchService.shared.user(success: { (twitchUser) in
                
                let oldFollowers = Set(self.user?.followedUsers ?? [])
                self.user = twitchUser
                
                // Intentamos recuperar sus datos si ya se encuentra dado de alta
                FirebaseRDBService.shared.user(user: twitchUser) { (user) in
                    self.mergeUsers(user: user, oldFollowers: oldFollowers, success: success)
                } failure: { (_) in
                    FirebaseRDBService.shared.user(user: twitchUser, forceStreamer: true) { (user) in
                        self.mergeUsers(user: user, oldFollowers: oldFollowers, success: success)
                    } failure: { (_) in
                        self.reloadStreamers {
                            self.save()
                            success()
                        }
                    }
                }
            }, failure: failure, authFailure: failure)
        }, failure: failure)
    }
    
    func revoke(success: @escaping () -> Void) {
        
        if let accessToken = token?.accessToken {
            TwitchService.shared.revoke(accessToken: accessToken) {
                self.clear(completion: success)
            } failure: { (_) in
                self.clear(completion: success)
            }
        }
    }
    
    func delete(success: @escaping () -> Void) {
        
        if let accessToken = token?.accessToken {
            TwitchService.shared.revoke(accessToken: accessToken) {
                self.remove(completion: success)
            } failure: { (_) in
                self.remove(completion: success)
            }
        }
    }
    
    func save(schedule: [UserSchedule]) {
        
        if user?.schedule != schedule {
            user?.schedule = schedule
            if let user = user {
                UserDefaultsProvider.setCodable(key: .authUser, value: user)
                FirebaseRDBService.shared.saveSchedule(user: user)
            }
        }
    }
    
    func save(settings: UserSettings) {
        
        if user?.settings != settings {
            user?.settings = settings
            if let user = user {
                UserDefaultsProvider.setCodable(key: .authUser, value: user)
                FirebaseRDBService.shared.saveSettings(user: user)
            }
        }
    }


    func save(followedUser: User) {
        
        let login = followedUser.login ?? ""
        
        if let index = user?.followedUsers?.firstIndex(of: login) {
            user?.followedUsers?.remove(at: index)
            streamers?.removeAll(where: { user in
                return user.login == login
            })
            
            setupNotification(add: false, topic: login)
        } else {
            if user?.followedUsers == nil {
                user?.followedUsers = []
            }
            user?.followedUsers?.append(login)
            if streamers == nil {
                streamers = []
            }
            streamers?.append(followedUser)
            
            setupNotification(add: true, topic: login)
        }
        
        if let user = user {
            UserDefaultsProvider.setCodable(key: .authUser, value: user)
            FirebaseRDBService.shared.saveFollowedUsers(user: user)
        }
    }
    
    func save(streamer: Bool) {
        user?.streamer = streamer        
        save()
    }
    
    func fullReloadUser(completion: @escaping () -> Void) {
        
        FirebaseRCService.shared.fetch {
            TwitchService.shared.user { (twitchUser) in
                
                let schedule = self.user?.schedule
                let followedUsers = self.user?.followedUsers
                let streamer = self.user?.streamer
                
                self.user = twitchUser
                self.user?.schedule = schedule
                self.user?.followedUsers = followedUsers
                self.user?.streamer = streamer
                
                self.reloadUser(override: true, completion: completion)
                
            } failure: { (_) in
                self.reloadUser(completion: completion)
            } authFailure: { (_) in
                self.clear(completion: completion)
            }
        }
    }
    
    func reloadUser(override: Bool = false, completion: @escaping () -> Void) {
        
        firebaseAuth {
            if let currentUser = self.user {
                FirebaseRDBService.shared.user(user: currentUser) { remoteUser in
                    self.saveNewUserAndReloadStreamers(currentUser: currentUser, newUser: remoteUser, override: override, completion: completion)
                } failure: { _ in
                    FirebaseRDBService.shared.user(user: currentUser, forceStreamer: true) { remoteUser in
                        self.saveNewUserAndReloadStreamers(currentUser: currentUser, newUser: remoteUser, override: override, completion: completion)     
                    } failure: { _ in
                        self.reloadStreamers(completion: completion)
                    }
                }
            } else { completion() }
        }
    }
    
    func reloadStreamers(completion: @escaping () -> Void) {
        
        if let followedUsers = user?.followedUsers, !followedUsers.isEmpty {
            FirebaseRDBService.shared.streamers(ids: followedUsers) { (streamers) in
                self.streamers = streamers
                UserDefaultsProvider.setCodable(key: .streamers, value: Users(data: streamers))
                completion()
            }
        } else {
            self.streamers = nil
            UserDefaultsProvider.remove(key: .streamers)
            completion()
        }
    }
    
    func sortedStreamings() -> [SortedStreaming]? {
        
        if let streamers = streamers {
            
            var sortedStreamings: [SortedStreaming] = []
            
            // Se obtiene la emisión más reciente de cada streamer
            
            let currentDate = Date()
            
            streamers.forEach { (streamer) in
                
                if !(streamer.settings?.onHolidays ?? false) {
                
                    var nextSchedule: UserSchedule?
                    
                    streamer.schedule?.forEach({ (schedule) in
                        
                        if schedule.enable {
                            
                            let weekDate = schedule.weekDate()
                            
                            if (nextSchedule == nil && weekDate > currentDate) || (weekDate > currentDate && weekDate < nextSchedule!.date) {
                                nextSchedule = schedule
                            }
                        }
                    })
                    
                    if let nextSchedule = nextSchedule {
                        sortedStreamings.append((streamer, nextSchedule))
                    }
                }
            }
            
            // Se ordenan los streaming por emisión
            
            sortedStreamings.sort { (firstStreaming, secondStreaming) -> Bool in
                return firstStreaming.schedule.date < secondStreaming.schedule.date
            }
            
            return sortedStreamings
        }
        return nil
    }
    
    func save(token: TwitchToken) {
        self.token = token
        UserDefaultsProvider.setCodable(key: .token, value: token)
    }
        
    func setupNotification() {
     
        let topic = Constants.kMainNotificationTopic
        let streamerTopic = Constants.kStreamerNotificationTopic
        let noStreamerTopic = Constants.kNoStreamerNotificationTopic
        let languageCode = (Locale.current.languageCode ?? LanguageType.en.rawValue).uppercased()
        
        let subscribeLanguageType: LanguageType = (languageCode == LanguageType.es.rawValue) ? .es : .en
        let unsubscribeLanguageType: LanguageType = (languageCode != LanguageType.es.rawValue) ? .es : .en
        
        let messaging = Messaging.messaging()
        messaging.subscribe(toTopic: "\(topic)\(subscribeLanguageType.rawValue)")
        messaging.unsubscribe(fromTopic: "\(topic)\(unsubscribeLanguageType.rawValue)")
        if user?.streamer ?? false {
            messaging.subscribe(toTopic: "\(streamerTopic)\(subscribeLanguageType.rawValue)")
            messaging.unsubscribe(fromTopic: "\(streamerTopic)\(unsubscribeLanguageType.rawValue)")
            messaging.unsubscribe(fromTopic: "\(noStreamerTopic)\(subscribeLanguageType.rawValue)")
            messaging.unsubscribe(fromTopic: "\(noStreamerTopic)\(unsubscribeLanguageType.rawValue)")
        } else {
            messaging.subscribe(toTopic: "\(noStreamerTopic)\(subscribeLanguageType.rawValue)")
            messaging.unsubscribe(fromTopic: "\(noStreamerTopic)\(unsubscribeLanguageType.rawValue)")
            messaging.unsubscribe(fromTopic: "\(streamerTopic)\(subscribeLanguageType.rawValue)")
            messaging.unsubscribe(fromTopic: "\(streamerTopic)\(unsubscribeLanguageType.rawValue)")
        }
                
        user?.followedUsers?.forEach({ (user) in
            self.setupNotification(add: true, topic: user)
        })
    }
    
    func syncSchedule(completion: @escaping () -> Void) {
        
        if let broadcasterId = user?.id {
        
            TwitchService.shared.schedule(broadcasterId: broadcasterId) { segments in
                    
                var defaultSchedule = self.defaultSchedule()
                
                segments.forEach { segment in
                    if segment.isRecurring ?? false, let startDate = segment.startTime?.toRFC3339Date(), let endDate = segment.endTime?.toRFC3339Date() {

                        let weekdayType = startDate.weekdayType()
                        
                        var duration = Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour ?? 1
                        if duration < 1 {
                            duration = 1
                        } else if duration > 24 {
                            duration = 24
                        }
                        
                        if let index = defaultSchedule.firstIndex(where: { schedule in
                            return schedule.weekDay == weekdayType
                        }) {
                            defaultSchedule[index].date = startDate
                            defaultSchedule[index].duration = duration
                            defaultSchedule[index].enable = true
                        }
                    }
                }

                UserDefaultsProvider.set(key: .firstSync, value: true)
                
                self.save(schedule: defaultSchedule)

                completion()
            } failure: { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    // Private
    
    private func defaultUser() {
        
        if user == nil {
            
            // Usuario de sesión por defecto mientras no se autentica
            user = User()
            UserDefaultsProvider.setCodable(key: .authUser, value: user)
        }
    }
    
    private func saveNewUserAndReloadStreamers(currentUser: User, newUser: User, override: Bool, completion: @escaping () -> Void) {
        var user = newUser
        if override, user.override(user: currentUser) {
            self.user = user
            save()
        } else {
            self.user = user
            UserDefaultsProvider.setCodable(key: .authUser, value: user)
        }
        reloadStreamers(completion: completion)
    }
    
    private func mergeUsers(user: User, oldFollowers: Set<String>, success: @escaping () -> Void) {
        
        self.user?.schedule = user.schedule
        self.user?.settings = user.settings
        
        // Merge followers
        let mergedFollowers = Array(oldFollowers.union(Set(user.followedUsers ?? [])))
        self.user?.followedUsers = mergedFollowers
        if mergedFollowers.isEmpty {
            self.user?.followedUsers = nil
        }
        
        self.user?.streamer = user.streamer
        
        self.user?.followedUsers?.forEach({ (user) in
            self.setupNotification(add: true, topic: user)
        })
        
        reloadStreamers {
            self.save()
            success()
        }
    }
    
    private func save() {
        
        // TODO: Guardar en firebase solo si se han modificado datos. Ahora se guarda siempre
        
        if user?.schedule?.isEmpty ?? true {
            user?.schedule = defaultSchedule()
        }
        
        if let user = user {
            
            UserDefaultsProvider.setCodable(key: .authUser, value: user)
            FirebaseRDBService.shared.save(user: user)
        }
    }
    
    private func defaultSchedule() -> [UserSchedule] {
        
        var schedule: [UserSchedule] = []
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        
        WeekdayType.allCases.forEach { (weekday) in
            schedule.append(UserSchedule(enable: false, weekDay: weekday, currentWeekDay: weekday, date: date, duration: 1, title: ""))
        }
        
        return schedule
    }
    
    private func setupNotification(add: Bool, topic: String) {
               
        if topic != Constants.kAdminLogin && topic == user?.login {
            return
        }
        
        let languageCode = (Locale.current.languageCode ?? LanguageType.en.rawValue).uppercased()
        let subscribeLanguageType: LanguageType = (languageCode == LanguageType.es.rawValue) ? .es : .en
        let unsubscribeLanguageType: LanguageType = (languageCode != LanguageType.es.rawValue) ? .es : .en

        let messaging = Messaging.messaging()
        
        if add {
            messaging.subscribe(toTopic: "\(topic)\(subscribeLanguageType.rawValue)")
            messaging.unsubscribe(fromTopic: "\(topic)\(unsubscribeLanguageType.rawValue)")
        } else {
            messaging.unsubscribe(fromTopic: "\(topic)\(subscribeLanguageType.rawValue)")
            messaging.unsubscribe(fromTopic: "\(topic)\(unsubscribeLanguageType.rawValue)")
        }
    }
    
    private func remove(completion: @escaping () -> Void) {
        
        if let user = user {
            FirebaseRDBService.shared.delete(user: user) {
                self.clear(completion: completion)
            } failure: { error in
                self.clear(completion: completion)
            }
        }
    }
    
    private func clear(completion: @escaping () -> Void) {
        
        user?.followedUsers?.forEach({ (user) in
            self.setupNotification(add: false, topic: user)
        })
        
        token = nil
        user = nil
        streamers = nil
        firebaseAuthUid = nil
        
        UserDefaultsProvider.clear()
        
        defaultUser()
        
        // Firebase Auth
        do {
            try Auth.auth().signOut()
            firebaseAuth(completion: completion)
        } catch let error as NSError {
            print ("Error signing out from Firebase: %@", error)
            firebaseAuth(completion: completion)
        }
    }
    
    private func firebaseAuth(completion: @escaping () -> Void) {
        
        // Firebase auth anónima y permanente para poder realizar operaciones autenticadas contra Firebase
        // TODO: Intentar integrar Twitch como sistema OAuth personalizado en Firebase
        if firebaseAuthUid == nil {
            Auth.auth().signInAnonymously() { (authResult, error) in
                guard let user = authResult?.user else { return }
                let uid = user.uid
                UserDefaultsProvider.set(key: .firebaseAuthUid, value: uid)
                completion()
            }
        } else {
            completion()
        }
    }
    
}
