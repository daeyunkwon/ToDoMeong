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
    }
    
    struct Output {
        var settings: [Setting] = [
            Setting(title: "화면 테마", type: .navigationLink),
            Setting(title: "문의하기", type: .button(detailType: .sendMail))
        ]
        
        var showMailView = false
    }
    
    init() {
        transform()
    }
    
    func transform() {
        
        input.isShowMailView
            .sink { [weak self] value in
                guard let self else { return }
                self.output.showMailView = value
            }
            .store(in: &cancellables)
        
    }
}

extension SettingViewModel {
    
    enum Action {
        case showMailView(isShow: Bool)
    }
    
    func action(_ action: Action) {
        switch action {
        case .showMailView(let isShow):
            input.isShowMailView.send(isShow)
        }
    }
}
