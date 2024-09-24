//
//  Date+Extension.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/13/24.
//

import Foundation

extension Date {
    
    var localDate: Date {
        let timeZone: TimeZone
        let currentLocale = Locale.current
        
        if currentLocale.region == "KR" {
            timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        } else if currentLocale.region == "JP" {
            timeZone = TimeZone(identifier: "Asia/Tokyo") ?? TimeZone.current
        } else {
            timeZone = TimeZone(identifier: "America/New_York") ?? TimeZone.current
        }
        
        let secondsFromGMT = timeZone.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(secondsFromGMT))
    }
    
    var dayOfTheWeekDateString: String {
        let formatter = DateFormatter()
        let currentLocale = Locale.current
        let timeZone: TimeZone
        
        if currentLocale.region == "KR" {
            timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 EEEE"
        } else if currentLocale.region == "JP" {
            timeZone = TimeZone(identifier: "Asia/Tokyo") ?? TimeZone.current
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "M月d日 EEEE"
        } else {
            timeZone = TimeZone(identifier: "America/New_York") ?? TimeZone.current
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "EEEE, MMM d"
        }
        
        formatter.timeZone = timeZone
        
        return formatter.string(from: self)
    }
    
    var yearMonthDateString: String {
        let formatter = DateFormatter()
        let currentLocale = Locale.current
        
        if currentLocale.region == "KR" {
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월"
        } else if currentLocale.region == "JP" {
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "yyyy年 M月"
        } else {
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "yyyy MMM"
        }
        
        return formatter.string(from: self)
    }
}
