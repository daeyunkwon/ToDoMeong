//
//  WillDisappearModifier.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/27/24.
//

import SwiftUI

private struct WillDisappearModifier: ViewModifier {
    
    private let callback: () -> Void
    
    fileprivate init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onWillDisappear: callback))
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        modifier(WillDisappearModifier(callback: perform))
    }
}




