//
//  SearchRowView.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import SwiftUI

struct SearchRowView: View {
    
    // Properties
    
    let user: User
    @State private var added: Bool = false
    @State private var showMaxStreamersAlert: Bool = false
    @State private var showRemoveStreamerAlert: Bool = false
    let addAction: () -> Void
    
    // Localization
    
    private let maxStreamersAlertTitleText = "search.maxstreamers.alert.title".localizedKey
    private let maxStreamersAlertTitleBody = "search.maxstreamers.alert.body".localizedKey
    private let removeStreamerAlertTitleText = "search.removestreamer.alert.title"
    private let removeStreamerAlertTitleBody = "search.removestreamer.alert.body".localizedKey
    private let okText = "accept".localizedKey
    private let cancelText = "cancel".localizedKey
    
    // Body
    
    var body: some View {
        HStack(alignment: .center, spacing: Size.none.rawValue) {
            
            Button(action: {
                add()
            }) {
                Image(added ? "calendar-remove" : "calendar-add").template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.mediumBig.rawValue, height: Size.mediumBig.rawValue).foregroundColor(.lightColor)
            }.buttonStyle(BorderlessButtonStyle()).padding(.leading, Size.medium.rawValue)
            .alert(isPresented: $showMaxStreamersAlert) { () -> Alert in
                Alert(title: Text(maxStreamersAlertTitleText), message: Text(maxStreamersAlertTitleBody), dismissButton: .default(Text(okText)))
            }
            .alert(isPresented: $showRemoveStreamerAlert) { () -> Alert in
                Alert(title: Text(String(format: removeStreamerAlertTitleText.localized, user.displayName ?? "")), message: Text(removeStreamerAlertTitleBody), primaryButton: .default(Text(okText), action: {
                    save()
                }), secondaryButton: .cancel(Text(cancelText)))
            }
            
            UserHeaderView(user: user, small: true)
        }
        .background(Color.secondaryColor)
        .opacity(added ? 1 : UIConstants.kViewOpacity)
        .cornerRadius(Size.big.rawValue)
        .shadow(radius: Size.verySmall.rawValue)
        .padding(.vertical, Size.small.rawValue)
        .listRowInsets(EdgeInsets())
        .padding(.horizontal, Size.medium.rawValue)
        .background(Color.secondaryBackgroundColor)
        .onAppear() {
            if let login = user.login {
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
        added.toggle()
        if let login = user.login {
            Session.shared.save(followedUser: login)
        }
        addAction()
    }
    
}

struct SearchRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchRowView(user: User(id: "1", login: "mouredev", displayName: "MoureDev", broadcasterType: .partner, descr: nil, profileImageUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png", offlineImageUrl: nil, schedule: nil), addAction: {
            
            print("addAction")
        })
    }
}
