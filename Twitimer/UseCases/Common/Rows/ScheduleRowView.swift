//
//  ScheduleRowView.swift
//  Twitimer
//
//  Created by Brais Moure on 21/4/21.
//

import SwiftUI
import Combine

struct ScheduleRowView: View {
    
    // Properties
    
    let type: WeekdayType
    @Binding var enable: Bool
    @Binding var date: Date
    @Binding var duration: Int
    @Binding var title: String
    let readOnly: Bool
    
    // Localization
    
    private let eventPlaceholderText = "schedule.event.placeholder".localizedKey
    
    // Body
    
    var body: some View {
        
        ZStack(alignment: .leading)  {
            
            HStack(spacing: Size.small.rawValue) {
                
                VStack(alignment: .trailing, spacing: Size.small.rawValue) {
                    
                    HStack(spacing: Size.small.rawValue) {
                        
                        if type == .custom {
                            Image("calendar-favorite").template
                                .resizable()
                                .foregroundColor(.lightColor)
                                .padding(Size.small.rawValue)
                                .frame(width: Size.veryBig.rawValue, height: Size.veryBig.rawValue)
                                .background(Color.primaryColor)
                                .clipShape(Circle())
                                .shadow(radius: Size.verySmall.rawValue)
                            
                        } else {
                            Text(type.name.first?.uppercased() ?? "").foregroundColor(.textColor)
                                .font(size: .title, type: .light)
                                .frame(width: Size.veryBig.rawValue, height: Size.veryBig.rawValue)
                                .background(Color.backgroundColor)
                                .clipShape(Circle())
                                .shadow(radius: Size.verySmall.rawValue)
                        }
                        
                        Text(type.name).font(size: .head).foregroundColor(.lightColor)
                        
                        Spacer()
                    }
                    
                    HStack(spacing: Size.verySmall.rawValue) {
                        
                        if type == .custom {
                            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute]).labelsHidden()
                                .datePickerStyle(.compact)
                                .accentColor(readOnly ? .lightColor : .primaryColor)
                                .colorScheme(.dark) // FIXME: Hack para que se vea el texto en blanco. No funciona accentColor en iOS 15
                                .padding(Size.verySmall.rawValue).disabled(!enable || readOnly)
                        } else {
                            
                            Image("time-clock-circle").templateIcon().foregroundColor(Color.lightColor)
                            
                            DatePicker("", selection: $date, displayedComponents: .hourAndMinute).labelsHidden().datePickerStyle(.compact).accentColor(.lightColor)
                                .colorScheme(.dark) // FIXME: Hack para que se vea el texto en blanco. No funciona accentColor en iOS 15
                                .disabled(!enable || readOnly)
                        }
                        
                        Image("hourglass").templateIcon().foregroundColor(Color.lightColor)
                        
                        Picker("\(readOnly ? "" : "+")\(duration)h", selection: $duration) {
                            ForEach((1...24), id: \.self) {
                                Text("+\($0)h").foregroundColor(.textColor)
                            }
                        }.font(size: .body)
                        .accentColor(.lightColor)
                        .pickerStyle(MenuPickerStyle())
                        .allowsHitTesting(!(!enable || readOnly))
                        
                    }.frame(height: Size.big.rawValue)
                    
                    if !readOnly || (readOnly && !title.isEmpty) {
                        
                        MainTextField(title: $title, placeholder: eventPlaceholderText, readOnly: readOnly, enable: enable)
                    }
                    
                }.padding(.vertical, Size.medium.rawValue)
            }
            .padding(.horizontal, Size.medium.rawValue)
            .if(!readOnly) {
                $0.padding(.leading, Size.big.rawValue)
            }
            .background(Color.secondaryColor)
            .opacity(enable ? 1 : UIConstants.kViewOpacity)
            .cornerRadius(Size.big.rawValue)
            .shadow(radius: Size.verySmall.rawValue)
            .padding(.vertical, Size.small.rawValue)
                        
            if !readOnly {
                
                ActionButton(image: Image(enable ? "check-circle" : "cursor-select-circle"), action: {
                    enable.toggle()
                })
                .padding(.leading, Size.medium.rawValue)
            }
        }
        .listRowInsets(EdgeInsets())
        .padding(.horizontal, Size.medium.rawValue)
        .background(Color.secondaryBackgroundColor)
    }
    
}

struct ScheduleRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        ScheduleRowView(type: .custom, enable: .constant(true), date: .constant(Date()), duration: .constant(1), title: .constant(""), readOnly: true)
    }
}
