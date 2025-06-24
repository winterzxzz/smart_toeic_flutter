//
//  ToeicWidget.swift
//  ToeicWidget
//
//  Created by Winter Phan on 23/6/25.
//

import WidgetKit
import SwiftUI
import UIKit

// MARK: - Timeline Provider

struct Provider: AppIntentTimelineProvider {
    private let userDefaults = UserDefaults(suiteName: "group.winterzxzz")
    
    func placeholder(in context: Context) -> FlashcardEntry {
        FlashcardEntry(date: Date(), flashcard: FlashCard(word: "No Data", definition: "Open the app to load flashcards."))
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> FlashcardEntry {
        FlashcardEntry(date: Date(), flashcard: FlashCard(word: "No Data", definition: "Open the app to load flashcards."))
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<FlashcardEntry> {
        print("📆 Widget timeline requested")
        let currentDate = Date()
        let flashcards = loadFlashcards()
        print("📦 Flashcards loaded in widget: \(flashcards.count)")
        var entries: [FlashcardEntry] = []
        
        guard !flashcards.isEmpty else {
            let fallbackEntry = FlashcardEntry(date: currentDate, flashcard: FlashCard(word: "No Data", definition: "Open the app to load flashcards."))
            return Timeline(entries: [fallbackEntry], policy: .never)
        }
        
        for i in 0..<flashcards.count {
            let entryDate = Calendar.current.date(byAdding: .minute, value: i * 15, to: currentDate)!
            let entry = FlashcardEntry(date: entryDate, flashcard: flashcards[i])
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .after(entries.last!.date))
    }
    
    // Load flashcards from shared App Group UserDefaults
    private func loadFlashcards() -> [FlashCard] {
        if let data = userDefaults?.data(forKey: "flashcards") {
            print("📦 Data found in UserDefaults")

            if let decoded = try? JSONDecoder().decode([FlashCard].self, from: data) {
                print("✅ Successfully decoded flashcards: \(decoded.count) items")
                return decoded
            } else {
                print("❌ Failed to decode flashcards")
            }
        } else {
            print("🚫 No data found for key 'flashcards'")
        }

        return []
    }
}

struct FlashcardEntry: TimelineEntry {
    let date: Date
    let flashcard: FlashCard
}

// MARK: - Widget View

struct ToeicWidgetEntryView: View {
    var entry: FlashcardEntry

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.flashcard.word.capitalizedFirst)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(entry.flashcard.definition.capitalizedFirst)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [Color.orange.opacity(0.3), Color.pink.opacity(0.1)],
                           startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(16)
        .widgetURL(URL(string: "test://winter-toeic.com/bottom-tab?isFromWidget=true"))
    }
}

extension String {
    var capitalizedFirst: String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
}

struct ToeicWidget: Widget {
    let kind: String = "ToeicWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ToeicWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.disableContentMarginsIfNeeded()
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

extension WidgetConfiguration {
    func disableContentMarginsIfNeeded() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}

#Preview(as: .systemMedium) {
    ToeicWidget()
} timeline: {
    FlashcardEntry(date: .now, flashcard: FlashCard(word: "winter", definition: "the coldest season of the year, in the northern hemisphere from December to February and in the southern hemisphere from June to August, characterized by shorter days and lower temperatures."))
}
