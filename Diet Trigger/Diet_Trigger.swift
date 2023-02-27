//
//  Diet_Trigger.swift
//  Diet Trigger
//
//  Created by Kim TaeSoo on 2023/02/27.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct Diet_TriggerEntryView : View {
    var entry: Provider.Entry
  
    @State var triggers: [String] = ["오늘 다이어트를 위해 무엇을 하셨나요?", "지친하루를 보낸 나에게 채찍질을 해주세요!", "오늘 맛있는 샐러드 한끼 어떠신가요?", "얼른 운동해야지\n-몸-"]
   
    var body: some View {
        VStack {
            Text(triggers.randomElement()!)
                .multilineTextAlignment(.center)
        }
    }
    
}

struct Diet_Trigger: Widget {
    let kind: String = "Diet_Trigger"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Diet_TriggerEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Diet_Trigger_Previews: PreviewProvider {
    static var previews: some View {
        Diet_TriggerEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
