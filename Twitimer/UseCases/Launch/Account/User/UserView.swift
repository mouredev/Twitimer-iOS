//
//  UserView.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

struct UserView: View {
    
    // Properties
    
    @ObservedObject var viewModel: UserViewModel
    @State private var isStreamer = false
    @State private var showCloseSessionAlert = false
    @State private var showSaveScheduleAlert = false
    @State private var showSyncScheduleAlert = false    
    
    // Localization
    
    let scheduleText = "schedule".localizedKey
    
    // Body
    
    var body: some View {
        VStack(spacing: Size.none.rawValue) {
            
            if viewModel.hasUser() {
                
                // Header
                
                VStack {
                    viewModel.userView()
                }
                
                // List
                
                VStack(alignment: .leading, spacing: Size.none.rawValue) {
                    
                    HStack {
                        
                        if isStreamer {
                            Text(viewModel.scheduleText).font(size: .head).foregroundColor(.textColor)
                            
                            if !viewModel.readOnly {
                                Button(action: {
                                    showSyncScheduleAlert.toggle()
                                }, label: {
                                    Image("calendar-refresh").resizable().renderingMode(.template).foregroundColor(.primaryColor).frame(width: Size.mediumBig.rawValue, height: Size.mediumBig.rawValue)
                                }).alert(isPresented: $showSyncScheduleAlert) { () -> Alert in
                                    Alert(title: Text(viewModel.syncAlertTitleText), message: Text(viewModel.syncAlertBodyText), primaryButton: .default(Text(viewModel.okText), action: {
                                        
                                        viewModel.syncSchedule()
                                        
                                    }), secondaryButton: .cancel(Text(viewModel.cancelText)))
                                }
                            }
                        }
                        
                        if !viewModel.readOnly {
                            
                            Spacer()
                            
                            Toggle(isOn: $isStreamer) {
                                Text(viewModel.streamerText).font(size: .subhead).foregroundColor(.textColor).frame(maxWidth: .infinity, alignment: .trailing)
                            }.toggleStyle(SwitchToggleStyle(tint: Color.primaryColor))
                            .onChange(of: isStreamer) {
                                if viewModel.isStreamer != isStreamer {
                                    viewModel.save(streamer: $0)
                                }
                            }
                        }
                        
                    }.padding(Size.medium.rawValue)
                    
                    if isStreamer {
                        if viewModel.readOnly && viewModel.schedule.isEmpty {
                            viewModel.emptyView()
                        } else {
                            List {
                                ForEach(Array(viewModel.schedule.enumerated()), id: \.offset) { index, schedule in
                                    ScheduleRowView(type: viewModel.readOnly ? schedule.currentWeekDay : schedule.weekDay,
                                                    enable: $viewModel.schedule[index].enable,
                                                    date: $viewModel.schedule[index].date,
                                                    duration: $viewModel.schedule[index].duration,
                                                    title: $viewModel.schedule[index].title,
                                                    readOnly: viewModel.readOnly)
                                }
                            }
                        }
                    } else {
                        viewModel.infoView()
                    }
                    
                }.background(Color.secondaryBackgroundColor)
                .cornerRadius(Size.big.rawValue, corners: [.topRight, .topLeft])
                .shadow(radius: Size.verySmall.rawValue)
                
                if !viewModel.readOnly {
                    
                    // Buttons
                    
                    HStack(spacing: Size.medium.rawValue) {
                        
                        MainButton(text: viewModel.closeText, action: {
                            showCloseSessionAlert.toggle()
                        }, type: .secondary)
                        .alert(isPresented: $showCloseSessionAlert) { () -> Alert in
                            Alert(title: Text(viewModel.closeText), message: Text(viewModel.closeAlertText), primaryButton: .default(Text(viewModel.okText), action: {
                                
                                viewModel.close()
                                
                            }), secondaryButton: .cancel(Text(viewModel.cancelText)))
                        }
                        
                        if isStreamer {
                            
                            MainButton(text: viewModel.saveText, action: {
                                showSaveScheduleAlert.toggle()
                            }, type: .primary)
                            .alert(isPresented: $showSaveScheduleAlert) { () -> Alert in
                                Alert(title: Text(viewModel.saveText), message: Text(viewModel.saveAlertText), primaryButton: .default(Text(viewModel.okText), action: {
                                    
                                    viewModel.save()
                                    
                                }), secondaryButton: .cancel(Text(viewModel.cancelText)))
                            }.enable(viewModel.enableSave())
                            
                        }
                        
                    }.padding(Size.medium.rawValue)
                    .background(Color.backgroundColor)
                    .shadow(radius: Size.verySmall.rawValue)
                }
            }
        }
        .background(Color.primaryColor).ignoresSafeArea(.container, edges: .top)
        .if(viewModel.readOnly) { $0.edgesIgnoringSafeArea(.bottom) }
        .navigationBarTitle("", displayMode: .inline)
        .ignoresSafeArea(.keyboard, edges: .top)
        .onAppear() {
            isStreamer = viewModel.isStreamer
            if isStreamer && !viewModel.readOnly && !viewModel.firstSync() {
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    DispatchQueue.main.async {
                        showSyncScheduleAlert.toggle()
                        UserDefaultsProvider.set(key: .firstSync, value: true)
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Image("twitimer_logo").resizable().aspectRatio(contentMode: .fit).frame(height: Size.mediumBig.rawValue)
            }
        }
    }
    
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserRouter.view(onClose: {
            print("onClose")
        })
    }
}
