//
//  ToeicWidget.swift
//  ToeicWidget
//
//  Created by Winter Phan on 23/6/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> FlashcardEntry {
        FlashcardEntry(date: Date(), flashcard: sampleFlashCards.first!)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> FlashcardEntry {
        FlashcardEntry(date: Date(), flashcard: sampleFlashCards.first!)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<FlashcardEntry> {
        let currentDate = Date()
        var entries: [FlashcardEntry] = []
        let flashcardsCount = sampleFlashCards.count

        for i in 0..<flashcardsCount {
            let entryDate = Calendar.current.date(byAdding: .minute, value: i * 15, to: currentDate)!
            let entry = FlashcardEntry(date: entryDate, flashcard: sampleFlashCards[i])
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct FlashcardEntry: TimelineEntry {
    let date: Date
    let flashcard: FlashCard
}

struct FlashCard: Codable, Identifiable {
    var id = UUID()
    let word: String
    let definition: String
}

let sampleFlashCards: [FlashCard] = [
    FlashCard(word: "Aberration", definition: "A departure from what is normal or expected."),
    FlashCard(word: "Benevolent", definition: "Well meaning and kindly."),
    FlashCard(word: "Cacophony", definition: "A harsh, discordant mixture of sounds."),
    FlashCard(word: "Debilitate", definition: "To make someone weak and infirm."),
    FlashCard(word: "Ebullient", definition: "Cheerful and full of energy.")
]

struct ToeicWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            
        
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.flashcard.word)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(entry.flashcard.definition)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color.orange.opacity(0.3), Color.pink.opacity(0.1)], startPoint: .top, endPoint: .bottom))
        .cornerRadius(16)
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
    FlashcardEntry(date: .now, flashcard: sampleFlashCards[0])
    FlashcardEntry(date: .now, flashcard: sampleFlashCards[1])
}
