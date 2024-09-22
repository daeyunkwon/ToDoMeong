//
//  FSCalendarView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/20/24.
//

import SwiftUI
import FSCalendar

struct FSCalendarView: UIViewRepresentable {
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: FSCalendarView

        init(_ parent: FSCalendarView) {
            self.parent = parent
        }

        // FSCalendar의 이벤트를 처리할 수 있는 delegate 메서드
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            let currentLocale = Locale.current
            let timeZone: TimeZone
            
            
            switch currentLocale.region {
            case "KR": // 한국
                timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
                
            case "JP": // 일본
                timeZone = TimeZone(identifier: "Asia/Tokyo") ?? TimeZone.current
                
            case "US", "GB", "AU": // 영어권 (미국, 영국, 호주 등)
                timeZone = TimeZone(identifier: "America/New_York") ?? TimeZone.current
                
            default:
                timeZone = TimeZone.current
            }
            
            // 선택된 날짜를 해당 국가 시간대로 변환
            let selectedDateInTimeZone = Calendar.current.date(byAdding: .hour, value: timeZone.secondsFromGMT(for: date) / 3600, to: date) ?? date
            
            parent.selectedDate = selectedDateInTimeZone
            
            print(Calendar.current.isDateInToday(parent.selectedDate))
        }

        
        func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            if Calendar.current.isDateInToday(date) {
                return "오늘"
            }
            return nil
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            let day = Calendar.current.component(.weekday, from: date) - 1
            
            let current = Calendar.current.dateComponents([.year, .month, .day], from: parent.selectedDate) //현재 페이지
            let compare = Calendar.current.dateComponents([.year, .month, .day], from: date) //비교하고 싶은 날짜
            
            if Calendar.current.isDateInToday(date) {
                return .label //오늘
            } else if Calendar.current.shortWeekdaySymbols[day] == "일" || Calendar.current.shortWeekdaySymbols[day] == "Sun" && current.month  == compare.month {
                return .systemRed //현재 선택한 월에 포함되는 일요일
            } else if Calendar.current.shortWeekdaySymbols[day] == "일" || Calendar.current.shortWeekdaySymbols[day] == "Sun" {
                return .systemRed.withAlphaComponent(0.5) //현재 선택한 월에 포함되지 않는 일요일
            } else {
                return nil //그 외 색상 설정 안함
            }
        }
        
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            DispatchQueue.main.async {
                self.parent.currentPageDate = calendar.currentPage
            }
        }
        
        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
            let repo = TodoRepository()
            let todos = repo.fetchTodo(date: date)
            
            if !todos.isEmpty {
                return resizeImage(image: UIImage(named: "pawprint") ?? UIImage(), targetSize: CGSize(width: 13, height: 13))?.withTintColor(.label)
            } else {
                return nil
            }
        }
        
        private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
            let size = image.size
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height

            // Determine the scale factor that preserves aspect ratio
            let scaleFactor = min(widthRatio, heightRatio)

            // Compute the new image size that preserves aspect ratio
            let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

            // Draw the scaled image
            UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: scaledSize))

            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return scaledImage?.withRenderingMode(.automatic)
        }
        
        
        
    }

    @Binding var selectedDate: Date
    @Binding var currentPageDate: Date
    @Binding var moveToday: Bool
    @Binding var isImageUpdate: Bool
    

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        
        let currentLocale = Locale.current
        if currentLocale.region == "KR" {
            calendar.locale = Locale(identifier: "ko_KR")
        } else if currentLocale.region == "JP" {
            calendar.locale = Locale(identifier: "ja_JP")
        } else {
            calendar.locale = Locale(identifier: "en_US")
        }
        
        calendar.headerHeight = 0
        calendar.appearance.titleDefaultColor = .label //평일
        calendar.appearance.titleWeekendColor = .label //주말
        calendar.appearance.todayColor = .clear
        calendar.appearance.subtitleTodayColor = .systemPink.withAlphaComponent(0.7)
        calendar.appearance.subtitleFont = UIFont(name: "Jalnan2", size: 9)
        calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        calendar.appearance.selectionColor = .brandGreen
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 14)
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 12)
        calendar.appearance.imageOffset = CGPoint(x: 0, y: 5)
        calendar.appearance.borderRadius = 0.5
        calendar.appearance.calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        
        
        calendar.select(Date())
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        
        //오늘 버튼 액션
        if moveToday {
            uiView.setCurrentPage(Date(), animated: true) //오늘 버튼 클릭
            uiView.select(Date())
            DispatchQueue.main.async {
                self.selectedDate = Date()
                self.moveToday = false
            }
            
        }
        
        if isImageUpdate {
            DispatchQueue.main.async {
                uiView.reloadData()
                isImageUpdate = false
            }
        }
    }
}
