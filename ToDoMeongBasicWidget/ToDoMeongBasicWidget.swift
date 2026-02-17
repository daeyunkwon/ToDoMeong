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
        SimpleEntry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: 0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let userDefaults = UserDefaults.init(suiteName: "group.com.daeyunkwon.ToDoMeong")
        let todayCount = userDefaults?.integer(forKey: "count") ?? 0
        let tomorrowCount = userDefaults?.integer(forKey: "tomorrow") ?? 0
        
        // 현재 시점의 entry 추가
        let entry = SimpleEntry(date: currentDate, count: todayCount)
        entries.append(entry)
        
        // 다음 자정 entry 추가
        let calendar = Calendar.current
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDate) else { return }
        let tomorrowStart = calendar.startOfDay(for: tomorrow)
        let nextEntry = SimpleEntry(date: tomorrowStart, count: tomorrowCount)
        entries.append(nextEntry)
        
        
        let timeline = Timeline(entries: entries, policy: .after(tomorrowStart))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
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
