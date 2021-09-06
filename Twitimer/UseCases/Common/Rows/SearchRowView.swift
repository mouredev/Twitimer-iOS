//
//  SearchRowView.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import SwiftUI

struct SearchRowView: View {
    
    // Properties
    
    let user: User? // Primario
    let userSearch: UserSearch? // Secundario
    @State private var added: Bool = false
    @State private var showMaxStreamersAlert: Bool = false
    @State private var showRemoveStreamerAlert: Bool = false
    let addAction: (() -> Void)?
    
    private var login: String? {
        return user?.login ?? userSearch?.broadcasterLogin
    }
    
    private var displayName: String? {
        return user?.displayName ?? userSearch?.displayName
    }
    
    private var profileImageUrl: String? {
        return user?.profileImageUrl ?? userSearch?.thumbnailUrl
    }
    
    private var broadcasterType: BroadcasterType? {
        return user?.broadcasterType
    }
    
    private var settings: UserSettings? {
        return user?.settings
    }
    
    private var isStreamer: Bool {
        return user?.streamer ?? false
    }
    
    private var isSearch: Bool {
        return userSearch != nil
    }
    
    // Localization
    
    private let maxStreamersAlertTitleText = "search.maxstreamers.alert.title".localizedKey
    private let maxStreamersAlertTitleBody = "search.maxstreamers.alert.body".localizedKey
    private let removeStreamerAlertTitleText = "search.removestreamer.alert.title"
    private let removeStreamerAlertTitleBody = "search.removestreamer.alert.body".localizedKey
    private let okText = "accept".localizedKey
    private let cancelText = "cancel".localizedKey
    
    // Body
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            UserHeaderView(profileImageUrl: profileImageUrl, login: login, displayName: displayName, broadcasterType: broadcasterType, settings: settings, isStreamer: isStreamer, small: true, readOnly: true, onClose: nil)
                .padding(.leading, isSearch && !added ? Size.none.rawValue : Size.big.rawValue)
                .background(Color.secondaryColor)
                .opacity(isSearch ? 1 : (added ? 1 : UIConstants.kViewOpacity))
                .cornerRadius(Size.big.rawValue)
                .shadow(radius: Size.verySmall.rawValue)
                .padding(.vertical, Size.small.rawValue)
            
            if (isSearch && added) || !isSearch {
            
                ActionButton(image: Image((isSearch && added) ? "calendar" : (added ? "calendar-remove" : "calendar-add")), padding: isSearch ? .extraSmall : .none, action: {
                    add()
                })
                .padding(.leading, Size.medium.rawValue)
                .disabled(isSearch)
                .alert(isPresented: $showMaxStreamersAlert) { () -> Alert in
                    Alert(title: Text(maxStreamersAlertTitleText), message: Text(maxStreamersAlertTitleBody), dismissButton: .default(Text(okText)))
                }
                .alert(isPresented: $showRemoveStreamerAlert) { () -> Alert in
                    Alert(title: Text(String(format: removeStreamerAlertTitleText.localized, displayName ?? "")), message: Text(removeStreamerAlertTitleBody), primaryButton: .default(Text(okText), action: {
                        save()
                    }), secondaryButton: .cancel(Text(cancelText)))
                }
            }
        }
        .listRowInsets(EdgeInsets())
        .padding(.horizontal, Size.medium.rawValue)
        .background(Color.secondaryBackgroundColor)
        .onAppear() {
            if let login = login {
                added = Session.shared.user?.followedUsers?.contains(login) ?? false
            }
        }
        
    }
    
    // MARK: Functions
    
    private func add() {
        if !added && Session.shared.user?.followedUsers?.count == Constants.kMaxStreamers {
            // No se pueden añadir más streamers
            showMaxStreamersAlert.toggle()
        } else if added {
            // Se notifica el borrado
            showRemoveStreamerAlert.toggle()
        } else {
            save()
        }
    }
    
    private func save() {
        if let user = user {
            added.toggle()
            Session.shared.save(followedUser: user)
            addAction?()
        }
    }
        
}

struct SearchRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchRowView(user: User(id: "1", login: "mouredev", displayName: "MoureDev", broadcasterType: .partner, descr: nil, profileImageUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png", offlineImageUrl: nil, schedule: nil), userSearch: nil, addAction: {
            
            print("addAction")
        })
    }
}
