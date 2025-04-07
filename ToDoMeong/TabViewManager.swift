//
//  TabViewManager.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/26/24.
//

import Foundation

final class TabViewManager: ObservableObject {
    
    static let shared = TabViewManager()
    private init() {}
    
    @Published var isTabViewHidden: Bool = false
}
