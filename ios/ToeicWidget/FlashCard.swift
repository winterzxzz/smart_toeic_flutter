//
//  FlashCard.swift
//  Runner
//
//  Created by Winter Phan on 24/6/25.
//

import Foundation


struct FlashCard: Codable, Identifiable {
    var id = UUID()
    let word: String
    let definition: String
}
