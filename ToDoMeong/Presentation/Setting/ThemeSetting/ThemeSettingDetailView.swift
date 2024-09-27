//
//  ThemeSettingDetailView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/25/24.
//

import SwiftUI

struct ThemeSettingDetailView: View {
    
    @AppStorage("themeMode") var themeMode: String = ThemeMode.system.rawValue
    @EnvironmentObject private var tabViewManager: TabViewManager
    
    
    var body: some View {
        VStack(spacing: 10) {
            self.rowButton(title: "시스템 설정", option: nil) {
                themeMode = ThemeMode.system.rawValue
            }
            
            self.rowButton(title: "다크 모드", option: .dark) {
                themeMode = ThemeMode.dark.rawValue
            }
            
            self.rowButton(title: "라이트 모드", option: .light) {
                themeMode = ThemeMode.light.rawValue
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("화면 테마")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(getPreferredColorScheme())
        
        .onWillAppear {
            DispatchQueue.main.async {
                self.tabViewManager.isTabViewHidden = true
            }
        }
        .onWillDisappear {
            tabViewManager.isTabViewHidden = false
        }
    }
    
    private func getPreferredColorScheme() -> ColorScheme? {
        switch themeMode {
        case ThemeMode.dark.rawValue:
            return .dark
        case ThemeMode.light.rawValue:
            return .light
        default:
            return nil
        }
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
                            .font(.system(size: 15, weight: .medium))
                        Spacer()
                        if getPreferredColorScheme() == option {
                            Image("pawprint", bundle: nil)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color(uiColor: .label))
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
    ThemeSettingDetailView()
}
