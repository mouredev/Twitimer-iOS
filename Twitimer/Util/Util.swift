//
//  Util.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import UIKit
import AVKit

final class Util {
    
    static var audioPlayer: AVAudioPlayer?
    
    static func requestPushAuthorization(application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
    }
    
    static func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    static func openBrowser(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func version() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(version)(\(build))"
        }
        return ""
    }
    
    static func countdown(now: Date, end: Date) -> String {
        
        let calendar = Calendar(identifier: .gregorian)
        let timeValue = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: end)
        let day = timeValue.day!
        if day == 0 {
            return String(format: "%02d:%02d:%02d", timeValue.hour!, timeValue.minute!, timeValue.second!)
        }
        return String(format: "%0d \(day == 1 ? "countdown.day".localized : "countdown.days".localized) %02d:%02d:%02d", day, timeValue.hour!, timeValue.minute!, timeValue.second!)
    }
    
    static func easteregg(user: String) {
        if user == Constants.kAdminLogin {
            let sounds = ["easteregg1", "easteregg2", "easteregg3"]
            if let sound = Bundle.main.path(forResource: sounds.randomElement(), ofType: "m4a") {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                    audioPlayer?.play()
                } catch {
                    debugPrint("Audio play error:", error.localizedDescription)
                }
            }
        }
    }
    
}
