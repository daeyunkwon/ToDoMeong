//
//  FSCalendarView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/20/24.
//

import SwiftUI
import FSCalendar

struct FSCalendarView: UIViewRepresentable {
    
    @Binding var selectedDate: Date
    @Binding var currentPageDate: Date
    @Binding var moveToday: Bool
    @Binding var isImageUpdate: Bool
    @Binding var movePreviousMonth: Bool
    @Binding var moveNextMonth: Bool
    
    private enum UpdateType {
        case moveToday
        case isImageUpdate
        case movePreviousMonth
        case moveNextMonth
        case none
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        
        calendar.headerHeight = 0
        calendar.appearance.titleDefaultColor = .label //평일
        calendar.appearance.titleWeekendColor = .label //주말
        calendar.appearance.todayColor = .clear
        calendar.appearance.subtitleTodayColor = .systemOrange.withAlphaComponent(1)
        calendar.appearance.subtitleFont = UIFont(name: "Jalnan2", size: 9)
        calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        calendar.appearance.selectionColor = .brandGreen
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 14)
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 12)
        calendar.appearance.imageOffset = CGPoint(x: 0, y: 1)
        calendar.appearance.borderRadius = 0.5
        calendar.appearance.calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        
        calendar.select(Date())
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        
        var type: UpdateType
        
        if moveToday {
            type = .moveToday
        } else if movePreviousMonth {
            type = .movePreviousMonth
        } else if moveNextMonth {
            type = .moveNextMonth
        } else if isImageUpdate {
            type = .isImageUpdate
        } else {
            type = .none
        }
        
        switch type {
        case .moveToday:
            uiView.setCurrentPage(Date(), animated: true) //오늘 버튼 클릭
            uiView.select(Date())
            DispatchQueue.main.async {
                self.selectedDate = Date()
                self.moveToday = false
            }
            
        case .isImageUpdate:
            DispatchQueue.main.async {
                uiView.reloadData()
                isImageUpdate = false
            }
        
        case .movePreviousMonth:
            if !context.coordinator.stopFlagToPreviousMonth {
                context.coordinator.stopFlagToPreviousMonth = true
                let currentDate = uiView.currentPage
                let oneMonthAge = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? Date()
                uiView.setCurrentPage(oneMonthAge, animated: true)
                DispatchQueue.main.async {
                    self.movePreviousMonth = false
                    context.coordinator.stopFlagToPreviousMonth = false
                }
            }
            
        case .moveNextMonth:
            if !context.coordinator.stopFlagToNextMonth {
                context.coordinator.stopFlagToNextMonth = true
                let currentDate = uiView.currentPage
                let oneMonthLater = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? Date()
                uiView.setCurrentPage(oneMonthLater, animated: true)
                DispatchQueue.main.async {
                    self.moveNextMonth = false
                    context.coordinator.stopFlagToNextMonth = false
                }
            }
            
        case .none:
            break
        }
    }
}

//MARK: - Coordinator

extension FSCalendarView {
    final class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        private let parent: FSCalendarView
        
        var stopFlagToPreviousMonth = false
        var stopFlagToNextMonth = false
        var currentSelectedMonth = Date()
        
        init(_ parent: FSCalendarView) {
            self.parent = parent
        }
        
        // FSCalendar의 이벤트를 처리할 수 있는 delegate 메서드
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            
            parent.selectedDate = date
        }
        
        
        func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            if Calendar.current.isDateInToday(date) {
                return "today".localized()
            }
            
            return nil
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            
            let day = Calendar.current.component(.weekday, from: date) - 1
            
            let current = Calendar.current.dateComponents([.year, .month, .day], from: currentSelectedMonth) //현재 페이지
            let compare = Calendar.current.dateComponents([.year, .month, .day], from: date) //비교하고 싶은 날짜
            
            if Calendar.current.isDateInToday(date) {
                return .label //오늘
            } else if Calendar.current.shortWeekdaySymbols[day] == "일" || Calendar.current.shortWeekdaySymbols[day] == "Sun" || Calendar.current.shortWeekdaySymbols[day] == "日" {
                if current.month  == compare.month {
                    return .systemRed //현재 선택한 월에 포함되는 일요일
                } else {
                    return .systemRed.withAlphaComponent(0.5) //현재 선택한 월에 포함되지 않는 일요일
                }
            } else {
                return nil //그 외 색상 설정 안함
            }
        }
        
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            currentSelectedMonth = calendar.currentPage
            DispatchQueue.main.async {
                self.parent.currentPageDate = calendar.currentPage
            }
            calendar.reloadData()
        }
        
        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
            let repo = TodoRepository()
            let result = repo.fetchTodo(date: date) // 동기 처리로 진행
            var image: UIImage?
            
            switch result {
            case .success(let todos):
                if !todos.isEmpty {
                    image = resizeImage(image: UIImage(named: "pawprint") ?? UIImage(), targetSize: CGSize(width: 10, height: 10))?.withTintColor(.label)
                } else {
                    image = nil
                }
                
            case .failure(let error):
                print(error.description)
                image = nil
            }
            
            return image
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
}
