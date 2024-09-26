//
//  UIViewLifeCycleHandler.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/27/24.
//

import SwiftUI

struct UIViewLifeCycleHandler: UIViewControllerRepresentable {
    
    var onWillAppear: () -> Void = { }
    var onWillDisappear: () -> Void = { }
    
    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onWillAppear: onWillAppear, onWillDisappear: onWillDisappear)
    }

    class Coordinator: UIViewController {
        let onWillAppear: () -> Void
        let onWillDisappear: () -> Void

        init(onWillAppear: @escaping () -> Void, onWillDisappear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
    }
}
