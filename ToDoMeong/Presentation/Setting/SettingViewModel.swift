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
        let isShowMailView = PassthroughSubject<Bool, Never>()
        let setLocalAlarmOnOff = PassthroughSubject<Bool, Never>()
    }
    
    struct Output {
        var settings: [Setting] = [
            Setting(title: "displayTheme", type: .navigationLink(detailType: .theme)),
            Setting(title: "localAlarm", type: .toggleWithNavigationLink(detailType: .localAlarm)),
            Setting(title: "contactUs", type: .button(detailType: .sendMail)),
            Setting(title: "openSourceLicense", type: .navigationLink(detailType: .license)),
            Setting(title: "appVersion", type: .button(detailType: .appVersion))
        ]
        
        var showMailView = false
        var releaseVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        var isLocalAlarmOn: Bool = false
    }
    
    init() {
        transform()
        self.action(.toggleLocalAlarm(isOn: UserDefaults.standard.value(forKey: "isLocalAlarmOn") as? Bool ?? false))
    }
    
    func transform() {
        input.isShowMailView
            .sink { [weak self] value in
                guard let self else { return }
                self.output.showMailView = value
            }
            .store(in: &cancellables)
        
        input.setLocalAlarmOnOff
            .sink { [weak self] newValue in
                guard let self else { return }
                print("로컬알람 켬? -> \(newValue)")
                UserDefaults.standard.set(newValue, forKey: "isLocalAlarmOn")
                self.output.isLocalAlarmOn = newValue
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension SettingViewModel {
    enum Action {
        case showMailView(isShow: Bool)
        case toggleLocalAlarm(isOn: Bool)
    }
    
    func action(_ action: Action) {
        switch action {
        case .showMailView(let isShow):
            input.isShowMailView.send(isShow)
            
        case .toggleLocalAlarm(let isOn):
            input.setLocalAlarmOnOff.send(isOn)
        }
    }
}
