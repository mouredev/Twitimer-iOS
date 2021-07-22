//
//  TwitchService.swift
//  Twitimer
//
//  Created by Brais Moure on 19/4/21.
//

import Foundation
import Alamofire

final class TwitchService {
    
    // Initialization
    static let shared = TwitchService()
    
    // Properties
    
    private let kAuthErrorStatusCode = 401
    
    // MARK: API
    private enum TwitchServiceAPI {
        
        case authorize
        case token(String)
        case refreshToken(String)
        case revoke(String)
        case user
        case search(String)
        case schedule(String)
        
        func url() -> URL? {
            
            let authUri = Constants.kTwitchAuthUri
            let apiUri = Constants.kTwitchAPIUri
            let clientID = FirebaseRCService.shared.twitchClientID ?? ""
            let clientSecret = FirebaseRCService.shared.twitchClientSecret ?? ""
            
            switch self {
            case .authorize:
                return URL(string: "\(authUri)authorize?client_id=\(clientID)&redirect_uri=\(Constants.kTwitchRedirectUri)&response_type=code&scope=user:read:email")
            case .token(let authorizationCode):
                return URL(string: "\(authUri)token?client_id=\(clientID)&client_secret=\(clientSecret)&code=\(authorizationCode)&grant_type=authorization_code&redirect_uri=\(Constants.kTwitchRedirectUri)")
            case .refreshToken(let refreshToken):
                return URL(string: "\(authUri)token?client_id=\(clientID)&client_secret=\(clientSecret)&refresh_token=\(refreshToken)&grant_type=refresh_token")
            case .revoke(let accessToken):
                return URL(string: "\(authUri)revoke?client_id=\(clientID)&token=\(accessToken)")
            case .user:
                return URL(string: "\(apiUri)users")
            case .search(let query):
                return URL(string: "\(apiUri)search/channels?query=\(query)")
            case .schedule(let broadcasterId):
                return URL(string: "\(apiUri)schedule?broadcaster_id=\(broadcasterId)")
            }
        }
    }
    
    // MARK: Services
    
    let authorizeURL = TwitchServiceAPI.authorize.url()!
    
    func token(authorizationCode: String, success: @escaping (_ token: TwitchToken) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        guard let url = TwitchServiceAPI.token(authorizationCode).url() else {
            failure(nil)
            return
        }
        
        AF.request(url, method: .post).responseDecodable(of: TwitchToken.self) { response in
            if let token = response.value {
                success(token)
            } else {
                failure(response.error)
            }
        }
    }
    
    func revoke(accessToken: String, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        guard let url = TwitchServiceAPI.revoke(accessToken).url() else {
            failure(nil)
            return
        }
        
        AF.request(url, method: .post).response { reponse in
            switch reponse.result {
            case .success:
                success()
            case let .failure(error):
                failure(error)
            }
        }
    }
    
    func user(retry: Bool = false, success: @escaping (_ user: User) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        guard let url = TwitchServiceAPI.user.url() else {
            failure(nil)
            return
        }
        
        AF.request(url, headers: Session.shared.authHeaders).responseDecodable(of: Users.self) { response in
            
            if let user = response.value?.data?.first {
                success(user)
            } else if response.response?.statusCode == self.kAuthErrorStatusCode, let token = Session.shared.token?.refreshToken, !retry {
                self.refreshToken(refreshToken: token) {
                    // Retry
                    self.user(retry: true, success: success, failure: failure)
                } failure: { (error) in
                    failure(error)
                }
            } else {
                failure(response.error)
            }
        }
    }
    
    func search(retry: Bool = false, query: String, success: @escaping (_ users: [UserSearch]) -> Void, failure: @escaping (_ error: Error?) -> Void) {

        guard let url = TwitchServiceAPI.search(query.replacingOccurrences(of: " ", with: "")).url() else {
            failure(nil)
            return
        }
        
        AF.request(url, headers: Session.shared.authHeaders).responseDecodable(of: UsersSearch.self) { response in

            if var users = response.value?.data, !users.isEmpty {
                
                // Si existe un usuario concidente con la query, se sitúa de primero
                if let index = users.firstIndex(where: { user in
                    return user.broadcasterLogin?.lowercased() == query.lowercased()
                }) {
                    let user = users[index]
                    users.remove(at: index)
                    users.insert(user, at: 0)
                }
                
                success(users)
                
            } else if response.response?.statusCode == self.kAuthErrorStatusCode, let token = Session.shared.token?.refreshToken, !retry {
                self.refreshToken(refreshToken: token) {
                    // Retry
                    self.search(retry: true, query: query, success: success, failure: failure)
                } failure: { (error) in
                    failure(error)
                }
            } else {
                failure(response.error)
            }
        }
    }
    
    func schedule(broadcasterId: String, retry: Bool = false, success: @escaping (_ segments: [UserScheduleSegment]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        guard let url = TwitchServiceAPI.schedule(broadcasterId).url() else {
            failure(nil)
            return
        }
        
        AF.request(url, headers: Session.shared.authHeaders).responseDecodable(of: UserSchedules.self) { response in
            
            if let segments = response.value?.data?.segments, !segments.isEmpty {
                success(segments)
            } else if response.response?.statusCode == self.kAuthErrorStatusCode, let token = Session.shared.token?.refreshToken, !retry {
                self.refreshToken(refreshToken: token) {
                    // Retry
                    self.schedule(broadcasterId: broadcasterId, retry: true, success: success, failure: failure)
                } failure: { (error) in
                    failure(error)
                }
            } else {
                failure(response.error)
            }
        }
    }
    
    // MARK: Private
    
    private func refreshToken(refreshToken: String, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        guard let url = TwitchServiceAPI.refreshToken(refreshToken).url() else {
            failure(nil)
            return
        }
        
        AF.request(url, method: .post).responseDecodable(of: TwitchToken.self) { response in
            if let token = response.value {
                Session.shared.save(token: token)
                success()
            } else {
                failure(response.error)
            }
        }
    }
    
}
