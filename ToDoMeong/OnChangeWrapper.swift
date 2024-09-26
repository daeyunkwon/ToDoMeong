//
//  OnChangeWrapper.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/16/24.
//

import SwiftUI

private struct OnChangeWrapper<T: Equatable>: ViewModifier {
    
    let value: T
    
    let action: (T) -> Void
    
    func body(content: Content) -> some View {
        
        if #available(iOS 17.0, *) {
            content
                .onChange(of: value) {
                    action(value)
                }
        } else {
            content
                .onChange(of: value, perform: { value in
                    action(value)
                })
        }
    }
}

extension View {
    func onChange<T: Equatable>(value: T, action: @escaping (T) -> Void) -> some View {
        modifier(OnChangeWrapper(value: value, action: action))
    }
}
