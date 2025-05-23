//
//  WillAppearModifier.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/27/24.
//

import SwiftUI

private struct WillAppearModifier: ViewModifier {
    
    private let callback: () -> Void
    
    fileprivate init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onWillAppear: callback))
    }
}

extension View {
    func onWillAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(WillAppearModifier(callback: perform))
    }
}
