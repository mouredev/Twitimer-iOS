//
//  FirebaseRCService.swift
//  Twitimer
//
//  Created by Brais Moure on 25/4/21.
//

import Foundation
import FirebaseRemoteConfig

final class FirebaseRCService {
    
    // Initialization
    static let shared = FirebaseRCService()
    
    // Parameters
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    private(set) var twitchClientID: String?
    private(set) var twitchClientSecret: String?
    
    // Initialization
    
    init() {
        
    }
    
    // Public
    
    func fetch(completion: @escaping () -> Void) {
        
        remoteConfig.fetchAndActivate { status, error in
            if status != .error {
                self.twitchClientID = self.remoteConfig.configValue(forKey: Constants.kRemoteTwitchClientID).stringValue
                self.twitchClientSecret = self.remoteConfig.configValue(forKey: Constants.kRemoteTwitchClientSecret).stringValue
            }
            completion()
        }
    }
    
}
