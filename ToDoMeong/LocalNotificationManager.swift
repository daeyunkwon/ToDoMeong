//
//  LocalNotificationManager.swift
//  ToDoMeong
//
//  Created by 권대윤 on 8/15/25.
//

import Foundation
import UserNotifications

final class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    private init() { }
    
    func checkPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status: UNAuthorizationStatus = settings.authorizationStatus
            let granted: Bool = (status == .ephemeral || status == .authorized)
            
            completion(granted)
        }
    }
    
    func registerDailyNotification(title: String, body: String, hour: Int, minute: Int) async {
        let list: [UNNotificationRequest] = await UNUserNotificationCenter.current().pendingNotificationRequests()
        if !list.isEmpty { clear() }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 0
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("알림 스케줄 등록 성공 -> \(hour):\(minute)")
        } catch {
            print("알림 스케줄 등록 실패: \(error)")
        }
    }
    
    func clear() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("알림 전체 삭제 완료")
    }
}
