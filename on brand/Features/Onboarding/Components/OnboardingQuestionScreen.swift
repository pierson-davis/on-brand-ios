import SwiftUI

struct OnboardingQuestionScreen: View {
    let model: OnboardingScreen
    let question: QuizQuestion
    let onSelect: (Int) -> Void
    let selectedIndex: Int?
    
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingProgressHeader(index: model.progressIndex,
                                     total: model.total,
                                     title: question.prompt,
                                     subtitle: "Tell Era how you vibe",
                                     progressLabel: model.progressLabel)

            VStack(spacing: 16) {
                ForEach(Array(question.answers.enumerated()), id: \.element.id) { index, answer in
                    EraSelectableCard(isSelected: selectedIndex == index) {
                        onSelect(index)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(answer.text)
                                .font(.headline)
                                .foregroundColor(themeManager.textPrimary)
                            if answer.weights.count > 1 {
                                Text(answer.weights.keys.map { $0.title }.joined(separator: " · "))
                                    .font(.footnote)
                                    .foregroundColor(themeManager.textSecondary)
                            }
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
    }
}

