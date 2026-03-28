//
//  ToDoMeongBasicWidget.swift
//  ToDoMeongBasicWidget
//
//  Created by 권대윤 on 10/21/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: "\(0)")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: "\(0)")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let calendar = Calendar.current
        let userDefaults = UserDefaults(suiteName: "group.com.daeyunkwon.ToDoMeong")
        
        let lastUpdatedDate = userDefaults?.object(forKey: "lastUpdatedDate") as? Date ?? Date.distantPast
        let savedTodayCount = userDefaults?.integer(forKey: "count") ?? 0
        let savedTomorrowCount = userDefaults?.integer(forKey: "tomorrow") ?? 0
        
        var actualTodayCount: String = "-"
        var actualTomorrowCount: String = "-"
        
        if calendar.isDateInToday(lastUpdatedDate) { // 오늘 업데이트
            actualTodayCount = "\(savedTodayCount)"
            actualTomorrowCount = "\(savedTomorrowCount)"
        }
        else if calendar.isDateInYesterday(lastUpdatedDate) { // 어제 업데이트
            actualTodayCount = "\(savedTomorrowCount)"
            actualTomorrowCount = "-"
        }
        else { // 2일 이상 경과한 경우
            actualTodayCount = "-"
            actualTomorrowCount = "-"
        }
        
        // 1️⃣ 현재 시점 엔트리 추가
        entries.append(SimpleEntry(date: currentDate, count: actualTodayCount))
        
        // 2️⃣ 내일 자정 엔트리 추가
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDate) {
            let tomorrowStart = calendar.startOfDay(for: tomorrow)
            
            // 내일 데이터를 알고 있다면 그 숫자를, 모른다면 "-"를 표시하도록 예약
            let nextEntry = SimpleEntry(date: tomorrowStart, count: actualTomorrowCount)
            entries.append(nextEntry)
        }
        
        // 정책 설정: 제출한 타임라인이 끝나면(자정 이후) 다시 getTimeline을 호출해라
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: String
}

struct ToDoMeongBasicWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Text("widget.title.today".localized())
                    .font(.system(size: 15, weight: .bold))
                
                Text("\(entry.count)")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(Color(uiColor: .systemOrange))
            }
            
            Image("pawprint", bundle: nil)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.primary) // 라이트 ro 다크모드에 따라 검정/흰색으로 자동 전환 처리
                .frame(width: 90, height: 90)
        }
    }
}

struct ToDoMeongBasicWidget: Widget {
    let kind: String = "ToDoMeongBasicWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ToDoMeongBasicWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ToDoMeongBasicWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("ToDoMeong Widget")
        //.description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

//#Preview(as: .systemSmall) {
//    ToDoMeongBasicWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}

