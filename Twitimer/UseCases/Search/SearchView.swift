//
//  SearchView.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import SwiftUI

struct SearchView: View {
    
    // Properties
    
    @ObservedObject var viewModel: SearchViewModel
    @State private var text: String = ""
    @State private var isEditing = false
    
    // Body
    
    var body: some View {
        ZStack {
            VStack(spacing: Size.none.rawValue) {
                
                // Header
                
                HStack(spacing: Size.none.rawValue) {
                                        
                    Image("search").template
                        .resizable().frame(width: Size.mediumBig.rawValue, height: Size.mediumBig.rawValue)
                        .foregroundColor(Color.textColor)
                        .padding(.leading, Size.medium.rawValue)
                        .opacity(UIConstants.kViewOpacity)
                    
                    TextField("", text: $text)
                        .modifier(TextFieldPlaceholderStyle(showPlaceHolder: text.isEmpty, placeholder: viewModel.searchPlaceholderText))
                        .padding(Size.small.rawValue)
                        .font(size: .body)
                        .foregroundColor(.textColor).accentColor(.textColor)
                        .onTapGesture {
                            viewModel.editing()
                            isEditing = true
                        }
                    
                    if isEditing {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(Color.textColor)
                                .padding(.trailing, Size.small.rawValue)
                                .opacity(UIConstants.kViewOpacity)
                        }
                    }
                    
                }
                .background(Color.backgroundColor)
                .clipShape(Capsule()).padding(Size.medium.rawValue)
                
                VStack(alignment: .leading, spacing: Size.none.rawValue) {
                    
                    if viewModel.users.isEmpty && viewModel.search.isEmpty && !isEditing && !viewModel.loading {
                        
                        // Info
                        
                        if text.isEmpty {
                            viewModel.infoSearchView()
                        } else {
                            viewModel.infoChannelView()
                        }
                        
                    } else {
                        
                        HStack(spacing: Size.none.rawValue) {
                            Text(!isEditing ? viewModel.followedstreamersText : viewModel.streamersText).font(size: .head).foregroundColor(.textColor).padding(Size.medium.rawValue)
                            
                            if !isEditing {
                                Spacer()
                                Text("\(viewModel.streamersCount)/\(Constants.kMaxStreamers)").font(size: .subhead).padding(Size.medium.rawValue)
                            }
                        }
                        
                        // List
                        
                        if let search = viewModel.search, !search.isEmpty {
                            List {
                                ForEach(search, id: \.id) { user in
                                    SearchQueryRowView(user: user).listRowInsets(EdgeInsets()).background(Color.backgroundColor)
                                        .onTapGesture {
                                            if let user = user.broadcasterLogin {
                                                viewModel.search(user: user)
                                            }
                                        }
                                }
                            }
                        } else {
                            List {
                                ForEach(viewModel.users, id: \.id) { user in
                                    ZStack {
                                        NavigationLink(destination: UserRouter.readOnlyView(user: user)) {}.opacity(0)
                                        SearchRowView(user: user, addAction: {
                                            viewModel.updateCount()
                                        })
                                    }.listRowInsets(EdgeInsets()).background(Color.backgroundColor)
                                }
                            }
                        }
                    }
                }.background(Color.secondaryBackgroundColor)
                .cornerRadius(Size.big.rawValue, corners: [.topRight, .topLeft])
                .shadow(radius: Size.verySmall.rawValue)
                
                // Buttons
                
                HStack(spacing: Size.medium.rawValue) {
                    
                    MainButton(text: viewModel.cancelText, action: {
                        text = ""
                        viewModel.cancel()
                        self.isEditing = false
                    }, type: .secondary).enable(enableCancel())
                    
                    MainButton(text: viewModel.searchText, action: {
                        viewModel.search(query: text)
                        self.isEditing = false
                    }, type: .primary).enable(enableSearch())
                    
                }.padding(Size.medium.rawValue)
                .background(Color.backgroundColor)
                .shadow(radius: Size.verySmall.rawValue)
                
            }
            .background(Color.primaryColor)
            .ignoresSafeArea(.keyboard, edges: .top)
            .onAppear() {
                if text.isEmpty {
                    viewModel.search(query: text)
                }
            }
            
            if viewModel.loading {
                CustomProgressView()
            }
        }
    }
    
    // Private
    
    private func enableCancel() -> Bool {
        return isEditing
            || (!isEditing && !viewModel.search.isEmpty)
            || (!isEditing && viewModel.users.isEmpty && viewModel.search.isEmpty)
    }
        
    private func enableSearch() -> Bool {
        return !text.isEmpty
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRouter.view().colorScheme(.dark)
    }
}
