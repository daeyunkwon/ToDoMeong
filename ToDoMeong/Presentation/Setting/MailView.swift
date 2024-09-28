//
//  MailView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/26/24.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult, error: Error?) {
            
            parent.isShowing = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = context.coordinator
            vc.setToRecipients(["sweet_ray@naver.com"])
            vc.setSubject("contactToDoMeong".localized())
            
            // 기기 정보 및 OS 버전
            let deviceInfo = """
                        Device: \(getDeviceModel())
                        OS Version: \(UIDevice.current.systemVersion)
                        """
            
            // 메일 본문 설정
            vc.setMessageBody("""
            \(deviceInfo)
            -------------------
            
            \("contactUs".localized()):
            """, isHTML: false)
            
            return vc
        } else {
            return UIViewController()
        }
    }
    
    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0)
            }
        }
        return modelCode ?? "unknown"
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
