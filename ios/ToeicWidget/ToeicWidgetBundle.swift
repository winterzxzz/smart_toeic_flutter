//
//  ToeicWidgetBundle.swift
//  ToeicWidget
//
//  Created by Winter Phan on 23/6/25.
//

import WidgetKit
import SwiftUI

@main
struct ToeicWidgetBundle: WidgetBundle {
    var body: some Widget {
        ToeicWidget()
        ToeicWidgetControl()
        ToeicWidgetLiveActivity()
    }
}
