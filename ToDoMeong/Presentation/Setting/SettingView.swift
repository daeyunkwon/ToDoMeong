//
//  SettingView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/23/24.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject private var viewModel = SettingViewModel()
    @EnvironmentObject private var tabViewManager: TabViewManager
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.output.settings, id: \.id) { item in
                        switch item.type {
                        case .navigationLink:
                            navigationLinkButtonRowView(item: item)
                        case .toggle:
                            EmptyView()
                        case .button:
                            buttonRowView(item: item)
                        }
                    }
                }
            }
            .padding(.top, 15)
            .safeAreaInset(edge: .bottom, content: {
                Color.clear.frame(height: 80)
            })
            
            .sheet(isPresented: $viewModel.output.showMailView, content: {
                MailView(isShowing: Binding(get: {
                    viewModel.output.showMailView
                }, set: { newValue in
                    viewModel.action(.showMailView(isShow: newValue))
                }))
                .tint(.blue)
            })
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("설정")
                        .font(Constant.AppFont.jalnanTopLeading)
                        .padding(.top, 15)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(Color(uiColor: .label))
    }
    
    private func navigationLinkButtonRowView(item: Setting) -> some View {
        NavigationLink {
            switch item.type {
            case .navigationLink(let detailType):
                switch detailType {
                case .theme:
                    NavigationLazyView(build: ThemeSettingDetailView())
                case .license:
                    NavigationLazyView(build: LicenseView())
                }
            default:
                EmptyView()
            }
        } label: {
            ZStack {
                Rectangle()
                    .frame(height: 55)
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .cornerRadius(0)
                HStack {
                    Text(item.title)
                        .font(.system(size: 15, weight: .medium))
                        .padding(.leading, 15)
                    Spacer()
                    Image(systemName: "chevron.forward")
                }
                .padding(.trailing, 15)
            }
            .padding(.horizontal, 0)
        }
        .buttonStyle(DefaultButtonStyle())
        .tint(Color(uiColor: .label))
    }
    
    private func toggleButtonRowView(isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn, label: {
            Text("Label")
                .font(.system(size: 15, weight: .medium))
        })
        .padding(.trailing, 5)
        .frame(height: 55)
        .background()
    }
    
    private func buttonRowView(item: Setting) -> some View {
        var rightTitle: String = ""
        
        //타입에 따라 오른쪽 타이틀 문구 분기 처리
        switch item.type {
        case .button(let detailType):
            switch detailType {
            case .appVersion:
                rightTitle = "1.0.0"
            default: break
            }
        default: break
        }
        
        return Button {
            //타입에 따라 버튼 동작 분기 처리
            switch item.type {
            case .button(let detailType):
                switch detailType {
                case .sendMail:
                    viewModel.action(.showMailView(isShow: true))
                case .appVersion:
                    break
                }
                
            default: break
            }
        } label: {
            Rectangle()
                .frame(height: 55)
                .foregroundStyle(Color(uiColor: .systemBackground))
                .cornerRadius(0)
                .overlay {
                    HStack {
                        Text(item.title)
                            .font(.system(size: 15, weight: .medium))
                            .padding(.leading, 15)
                        Spacer()
                        Text(rightTitle)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color(uiColor: .systemGray))
                    }
                    .padding(.trailing, 15)
                }
        }
        .buttonStyle(DefaultButtonStyle())
        .tint(Color(uiColor: .label))
    }
    
    
}

#Preview {
    SettingView()
}





