//
//  Date+Extension.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/13/24.
//

import Foundation

extension Date {
    
    var dateString: String {
        let formatter = DateFormatter()
        
        let currentLocale = Locale.current
        
        if currentLocale.region == "KR" {
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 EEEE"
        } else {
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "EEEE, MMM d"
        }
        
        return formatter.string(from: self)
    }
}
