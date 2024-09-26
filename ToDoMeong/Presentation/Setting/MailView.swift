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
            vc.setSubject("투두멍 문의하기")
            return vc
        } else {
            return UIViewController()
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
