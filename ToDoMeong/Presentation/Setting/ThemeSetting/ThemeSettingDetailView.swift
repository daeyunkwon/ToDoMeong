//
//  ThemeSettingDetailView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/25/24.
//

import SwiftUI

struct ThemeSettingDetailView: View {
    
    @AppStorage("themeMode") private var themeMode: String = ThemeMode.system.rawValue
    @EnvironmentObject private var tabViewManager: TabViewManager
    
    var body: some View {
        VStack(spacing: 10) {
            self.rowButton(title: "systemSettings".localized(), option: nil) {
                themeMode = ThemeMode.system.rawValue
            }
            
            self.rowButton(title: "darkMode".localized(), option: .dark) {
                themeMode = ThemeMode.dark.rawValue
            }
            
            self.rowButton(title: "lightMode".localized(), option: .light) {
                themeMode = ThemeMode.light.rawValue
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("displayTheme".localized())
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(getPreferredColorScheme())
        
        .onWillAppear {
            tabViewManager.isTabViewHidden = true
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
        .environmentObject(TabViewManager.shared)
}
