//
//  SettingViewModel.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/25/24.
//

import SwiftUI
import Combine

enum ThemeMode: String {
    case system
    case light
    case dark
}

final class SettingViewModel: ViewModelType {
        
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    struct Input {
        let changeThemeMode = PassthroughSubject<ThemeMode, Never>()
    }
    
    struct Output {
        var settings: [Setting] = [
            Setting(title: "화면 테마", type: .navigationLink)
        ]
        var themeMode: ColorScheme? = UserDefaultsManager.shared.themeMode == ThemeMode.dark.rawValue ? .dark : UserDefaultsManager.shared.themeMode == ThemeMode.light.rawValue ? .light : nil
    }
    
    init() {
        transform()
    }
    
    func transform() {
        
        input.changeThemeMode
            .sink { [weak self] themeMode in
                guard let self else { return }
                
                switch themeMode {
                case .system:
                    UserDefaultsManager.shared.themeMode = ThemeMode.system.rawValue
                    output.themeMode = .none
                case .light:
                    UserDefaultsManager.shared.themeMode = ThemeMode.light.rawValue
                    output.themeMode = .light
                case .dark:
                    UserDefaultsManager.shared.themeMode = ThemeMode.dark.rawValue
                    output.themeMode = .dark
                }
            }
            .store(in: &cancellables)
        
        
    }
}

extension SettingViewModel {
    enum Action {
        case themeMode(setting: ThemeMode)
    }
    
    func action(_ action: Action) {
        switch action {
        case .themeMode(let setting):
            input.changeThemeMode.send(setting)
        }
    }
}
