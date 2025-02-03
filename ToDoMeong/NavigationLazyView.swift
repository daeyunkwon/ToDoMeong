//
//  NavigationLazyView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/13/24.
//

import SwiftUI

struct NavigationLazyView<T: View>: View {
    
    private let build: () -> T
    
    init(build: @autoclosure @escaping () -> T) {
        self.build = build
    }
    
    var body: some View {
        build()
    }
}
