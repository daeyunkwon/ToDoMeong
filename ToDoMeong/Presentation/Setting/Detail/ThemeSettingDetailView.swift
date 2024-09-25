//
//  ThemeSettingDetailView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/25/24.
//

import SwiftUI

struct ThemeSettingDetailView: View {
    
    @StateObject var viewModel: SettingViewModel
    @AppStorage("themeMode") var themeMode: String = ThemeMode.system.rawValue
    
    var body: some View {
        VStack(spacing: 10) {
            
            self.rowButton(title: "시스템 설정", option: nil) {
                viewModel.action(.themeMode(setting: .system))
                themeMode = ThemeMode.system.rawValue
            }
            
            self.rowButton(title: "다크 모드", option: .dark) {
                viewModel.action(.themeMode(setting: .dark))
                themeMode = ThemeMode.dark.rawValue
            }
            
            self.rowButton(title: "라이트 모드", option: .light) {
                viewModel.action(.themeMode(setting: .light))
                themeMode = ThemeMode.light.rawValue
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("화면 테마")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(viewModel.output.themeMode)
    }
    
    private func rowButton(title: String, option: ColorScheme?, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Rectangle()
                .frame(height: 40)
                .foregroundStyle(Color(uiColor: .systemBackground))
                .cornerRadius(0)
                .overlay {
                    HStack {
                        Text(title)
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                        if viewModel.output.themeMode == option {
                            Image(systemName: "checkmark")
                        }
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
    ThemeSettingDetailView(viewModel: SettingViewModel())
}
