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
        let setLocalAlarmTime = PassthroughSubject<Date, Never>()
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
        var isLocalAlarmOn: Bool = UserDefaults.standard.value(forKey: "isLocalAlarmOn") as? Bool ?? false
        var localAlarmTime: Date = UserDefaults.standard.value(forKey: "localAlarmTime") as? Date ?? Date()
        var localAlarmTimeTitle: String = ""
    }
    
    init() {
        transform()
        output.localAlarmTimeTitle = localizedLocalAlarmTime(output.localAlarmTime)
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
                UserDefaults.standard.set(newValue, forKey: "isLocalAlarmOn")
                self.output.isLocalAlarmOn = newValue
            }
            .store(in: &cancellables)
        
        input.setLocalAlarmTime
            .sink { [weak self] time in
                guard let self else { return }
                UserDefaults.standard.set(time, forKey: "localAlarmTime")
                self.output.localAlarmTime = time
                self.output.localAlarmTimeTitle = self.localizedLocalAlarmTime(time)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension SettingViewModel {
    enum Action {
        case showMailView(isShow: Bool)
        case toggleLocalAlarm(isOn: Bool)
        case setLocalAlarmTime(time: Date)
    }
    
    func action(_ action: Action) {
        switch action {
        case .showMailView(let isShow):
            input.isShowMailView.send(isShow)
            
        case .toggleLocalAlarm(let isOn):
            input.setLocalAlarmOnOff.send(isOn)
            
        case .setLocalAlarmTime(let date):
            input.setLocalAlarmTime.send((date))
        }
    }
}

//MARK: - Logic

extension SettingViewModel {
    private func localizedLocalAlarmTime(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: TimeZone.current, from: date)
        let hour24 = components.hour ?? 0
        let minute = components.minute ?? 0

        let isAM: Bool = hour24 < 12
        let hour12: Int = hour24 % 12 == 0 ? 12 : hour24 % 12
        
        let langCode = Locale.current.language.languageCode?.identifier ?? "en"

        switch langCode {
        case "ko":
            let a = isAM ? "오전" : "오후"
            return String(format: "localAlarmTime_ko_jp".localized(), a, hour12, minute)

        case "ja":
            let a = isAM ? "午前" : "午後"
            return String(format: "localAlarmTime_ko_jp".localized(), a, hour12, minute)

        default:
            let a = isAM ? "AM" : "PM"
            return String(format: "localAlarmTime_en".localized(), hour12, minute, a)
        }
    }
}
