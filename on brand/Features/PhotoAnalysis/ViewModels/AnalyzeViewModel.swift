//
//  AnalyzeViewModel.swift
//  era
//

import SwiftUI

class AnalyzeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var aiNote: String?

    func runAnalysis(image: UIImage, vibe: String = "Freestyle") {
        runBatchAnalysis(images: [image], vibe: vibe)
    }

    func runBatchAnalysis(images: [UIImage], vibe: String, completion: (([UIImage]) -> Void)? = nil) {
        guard !images.isEmpty else {
            isLoading = false
            aiNote = "Add at least one photo to analyze."
            return
        }

        isLoading = true

        // TODO: Replace this stub with OpenAI/your API logic
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [weak self] in
            let count = max(1, images.count / 2)
            let chosen = Array(images.prefix(count))

            DispatchQueue.main.async {
                guard let self else { return }

                completion?(chosen)
                self.isLoading = false
                self.aiNote = "AI picked \(chosen.count) photo\(chosen.count == 1 ? "" : "s") for the \(vibe) vibe."
            }
        }
    }
}
