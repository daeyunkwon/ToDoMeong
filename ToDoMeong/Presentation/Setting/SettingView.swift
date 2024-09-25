//
//  SettingView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/23/24.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject private var viewModel = SettingViewModel()
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.output.settings, id: \.self) { item in
                        switch item.type {
                        case .navigationLink:
                            navigationLinkButtonRowView(item: item, destinationView: ThemeSettingDetailView(viewModel: viewModel))
                        case .toggle:
                            EmptyView()
                        case .button:
                            EmptyView()
                        }
                    }
                }
            }
            .padding(.top, 15)
            .background(Color(uiColor: .systemGray6))
            .safeAreaInset(edge: .bottom, content: {
                Color.clear.frame(height: 80)
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
        .preferredColorScheme(viewModel.output.themeMode)
        .tint(Color(uiColor: .label))
    }
    
    private func navigationLinkButtonRowView(item: Setting, destinationView: some View) -> some View {
        NavigationLink {
            NavigationLazyView(build: destinationView)
        } label: {
            ZStack {
                Rectangle()
                    .frame(height: 55)
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .cornerRadius(0)
                HStack {
                    Text(item.title)
                        .font(.system(size: 14, weight: .medium))
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
        })
        .padding(.trailing, 5)
        .frame(height: 55)
        .background()
    }
    
    private func buttonRowView(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Rectangle()
                .frame(height: 55)
                .foregroundStyle(Color(uiColor: .systemBackground))
                .cornerRadius(0)
                .overlay {
                    HStack {
                        Text("text")
                            .font(.headline)
                        Spacer()
                        Text("test")
                            .foregroundStyle(Color(uiColor: .systemGray))
                    }
                    .padding(.trailing, 15)
                    .background()
                }
        }
        .buttonStyle(DefaultButtonStyle())
        .tint(Color(uiColor: .label))
    }
}

#Preview {
    SettingView()
}
