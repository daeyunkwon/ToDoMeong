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

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let count = UserDefaults.init(suiteName: "group.com.daeyunkwon.ToDoMeong")?.integer(forKey: "count") ?? 0
            let entry = SimpleEntry(date: entryDate, count: count)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
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
                Text("오늘의 할 일")
                    .font(.system(size: 15, weight: .bold))
                Text("\(UserDefaults.init(suiteName: "group.com.daeyunkwon.ToDoMeong")?.integer(forKey: "count") ?? 0)")
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
