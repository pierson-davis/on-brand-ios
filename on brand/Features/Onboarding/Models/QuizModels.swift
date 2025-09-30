//
//  QuizModels.swift
//  era
//

import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case male = "male"
    case female = "female"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}

struct QuizAnswer: Identifiable {
    let id = UUID()
    let text: String
    /// Hidden weights toward archetypes (scorecard)
    let weights: [Archetype: Int]
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let answers: [QuizAnswer]
}

struct QuizScorecard {
    var scores: [Archetype: Int] = Archetype.allCases.reduce(into: [:]) { $0[$1] = 0 }

    mutating func apply(_ weights: [Archetype: Int]) {
        for (k, v) in weights { scores[k, default: 0] += v }
    }

    func top(_ n: Int = 2) -> [(Archetype, Int)] {
        scores.sorted { $0.value > $1.value }.prefix(n).map { ($0.key, $0.value) }
    }

    mutating func reset() {
        scores = Archetype.allCases.reduce(into: [:]) { $0[$1] = 0 }
    }
}
