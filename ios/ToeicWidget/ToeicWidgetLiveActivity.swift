//
//  ToeicWidgetLiveActivity.swift
//  ToeicWidget
//
//  Created by Winter Phan on 23/6/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ToeicWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ToeicWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ToeicWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ToeicWidgetAttributes {
    fileprivate static var preview: ToeicWidgetAttributes {
        ToeicWidgetAttributes(name: "World")
    }
}

extension ToeicWidgetAttributes.ContentState {
    fileprivate static var smiley: ToeicWidgetAttributes.ContentState {
        ToeicWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ToeicWidgetAttributes.ContentState {
         ToeicWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ToeicWidgetAttributes.preview) {
   ToeicWidgetLiveActivity()
} contentStates: {
    ToeicWidgetAttributes.ContentState.smiley
    ToeicWidgetAttributes.ContentState.starEyes
}
