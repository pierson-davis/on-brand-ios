//
//  VibeResult.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import Foundation

/// Represents the result of the onboarding quiz.
struct VibeResult: Identifiable, Hashable {
    let id = UUID()
    let primary: Archetype
    let secondary: Archetype?
    let description: String

    /// A simple text summary.
    var summary: String {
        if let secondary = secondary {
            return "Your vibe is \(primary.title) with a touch of \(secondary.title)."
        } else {
            return "Your vibe is \(primary.title)."
        }
    }
}
