//
//  HapticManager.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/14/24.
//

import SwiftUI

final class HapticManager {
    
    static let shared = HapticManager()
    private init() { }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func impact(intensity: Double) {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred(intensity: intensity)
    }
}
