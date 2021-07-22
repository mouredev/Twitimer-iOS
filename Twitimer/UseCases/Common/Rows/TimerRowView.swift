//
//  TimerRowView.swift
//  Twitimer
//
//  Created by Brais Moure on 23/4/21.
//

import SwiftUI

struct TimerRowView: View {
    
    // Properties
    
    let streaming: SortedStreaming
    let endDate: Date
    
    @State private var nowDate = Date()
    @State private var live = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()    
    
    // Body
    
    var body: some View {
        
        HStack(spacing: Size.small.rawValue) {
            
            VStack(alignment: .leading, spacing: Size.verySmall.rawValue) {
                
                HStack(alignment: .top, spacing: Size.small.rawValue) {
                    
                    UserAvatarView(url: streaming.streamer.profileImageUrl?.url, user: streaming.streamer.login ?? "", size: .veryBig)
                    
                    VStack(alignment: .leading, spacing: Size.verySmall.rawValue) {
                        
                        HStack {
                            Text(streaming.streamer.displayName ?? "").font(size: .head)
                            Spacer()
                            ChannelButton(login: streaming.streamer.login, darkBackground: true)
                        }
                        
                        Text(streaming.schedule.formattedDate()).font(size: .button, type: .light)
                        
                        if let title = streaming.schedule.title, !title.isEmpty {
                            HStack(spacing: Size.small.rawValue) {
                                Image("information").templateIcon().foregroundColor(.lightColor)
                                Text(title).foregroundColor(.lightColor).font(size: .caption)
                            }.padding(.top, Size.verySmall.rawValue)
                        }
                        
                    }.foregroundColor(.lightColor)
                    
                }                
                
                HStack(spacing: Size.small.rawValue) {
                    
                    Spacer()
                    
                    Image(live ? "button-record" : "time-clock-circle").templateIcon().foregroundColor(live ? .liveColor : .lightColor)
                    Text(timerFunction()).foregroundColor(.lightColor).font(size: .subhead, type: .bold)
                        .onReceive(timer, perform: { _ in
                            nowDate = Date()
                        })
                    
                    Image("hourglass").templateIcon().foregroundColor(.lightColor)
                    Text("\(streaming.schedule.duration)h").foregroundColor(.lightColor).font(size: .subhead, type: .bold)
                    
                }.frame(height: Size.big.rawValue)
                
            }.padding(.vertical, Size.medium.rawValue)
        }
        .padding(.horizontal, Size.medium.rawValue)
        .background(Color.secondaryColor)
        .cornerRadius(Size.big.rawValue)
        .shadow(radius: Size.verySmall.rawValue)
        .padding(.vertical, Size.small.rawValue)
        .listRowInsets(EdgeInsets())
        .padding(.horizontal, Size.medium.rawValue)
        .background(Color.secondaryBackgroundColor)
    }
    
    // Functions
    
    private func timerFunction() -> String {

        if endDate < nowDate {
            DispatchQueue.main.async { live = true }
            timer.upstream.connect().cancel()

            return "countdown.live".localized.uppercased()
        }
        
        DispatchQueue.main.async { live = false }
        return Util.countdown(now: nowDate, end: endDate)
    }
    
}

struct TimerRowView_Previews: PreviewProvider {
    static var previews: some View {
        TimerRowView(streaming: (User(id: "1", login: "mouredev", displayName: "MoureDev", broadcasterType: .partner, descr: nil, profileImageUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/da78091c-06f0-443c-bc6d-a1506a999d94-profile_image-300x300.png", offlineImageUrl: nil, schedule: nil), UserSchedule(enable: true, weekDay: .custom, currentWeekDay: .custom, date: Date().addingTimeInterval(4), duration: 2, title: "Custom title")), endDate: Date().addingTimeInterval(60 * 60))
    }
}
