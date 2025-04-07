//
//  Date+Extension.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/13/24.
//

import Foundation

extension Date {
    var dayOfTheWeekDateString: String {
        let formatStyle = Date.FormatStyle.dateTime.month().day().weekday(.wide)
        return self.formatted(formatStyle)
    }
    
    var yearMonthDateString: String {
        let formatStyle = Date.FormatStyle.dateTime.year().month()
        return self.formatted(formatStyle)
    }
}
