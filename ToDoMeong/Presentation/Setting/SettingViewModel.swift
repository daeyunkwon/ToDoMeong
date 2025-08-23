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
        var showNotiPermissionAlert: Bool = false
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
                
                Task {
                    await self.setLocalAlarm(with: newValue)
                }
                
                if newValue {
                    LocalNotificationManager.shared.checkPermission { granted in
                        DispatchQueue.main.async {
                            if !granted {
                                self.output.showNotiPermissionAlert = true
                                UserDefaults.standard.set(false, forKey: "isLocalAlarmOn")
                                self.output.isLocalAlarmOn = false
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        input.setLocalAlarmTime
            .sink { [weak self] time in
                guard let self else { return }
                UserDefaults.standard.set(time, forKey: "localAlarmTime")
                self.output.localAlarmTime = time
                self.output.localAlarmTimeTitle = self.localizedLocalAlarmTime(time)
                
                Task {
                    await self.setLocalAlarm(with: self.output.isLocalAlarmOn)
                }
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
        let (isAM, _, hour12, minute) = convertTimeComponents(date: date)
        let hour = String(hour12)
        
        let langCode = Locale.current.language.languageCode?.identifier ?? "en"

        switch langCode {
        case "ko":
            let a = isAM ? "오전" : "오후"
            return String(format: "localAlarmTime_ko_jp".localized(), a, hour, minute)

        case "ja":
            let a = isAM ? "午前" : "午後"
            return String(format: "localAlarmTime_ko_jp".localized(), a, hour, minute)

        default:
            let a = isAM ? "AM" : "PM"
            return String(format: "localAlarmTime_en".localized(), hour, minute, a)
        }
    }
    
    private func convertTimeComponents(date: Date) -> (Bool, Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: TimeZone.current, from: date)
        let hour24 = components.hour ?? 0
        let minute = components.minute ?? 0
        let isAM: Bool = hour24 < 12
        let hour12: Int = hour24 % 12 == 0 ? 12 : hour24 % 12
        
        return (isAM, hour24, hour12, minute)
    }
    
    private func setLocalAlarm(with isOn: Bool) async {
        if isOn {
            let title = "localAlarm.noti.title".localized()
            let (_, hour24, _, minute) = convertTimeComponents(date: self.output.localAlarmTime)
//            let hour = String(hour12)
            let body: String
            
//            let langCode = Locale.current.language.languageCode?.identifier ?? "en"
//            
//            switch langCode {
//            case "ko", "ja":
//                let a: String
//                
//                if langCode == "ko" {
//                    a = isAM ? "오전" : "오후"
//                } else {
//                    a = isAM ? "午前" : "午後"
//                }
//                
//                body = String(format: "localAlarm.noti.body_ko_jp".localized(), a, hour, minute)
//            
//            default:
//                let a = isAM ? "AM" : "PM"
//                body = String(format: "localAlarm.noti.body.en".localized(), hour, minute, a)
//            }
            
            body = "localAlarm.noti.body".localized()
            
            await LocalNotificationManager.shared.registerDailyNotification(title: title, body: body, hour: hour24, minute: minute)
        } else {
            LocalNotificationManager.shared.clear()
        }
    }
}
