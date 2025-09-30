import SwiftUI

struct OnboardingChecklistScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        if case let .benefits(title, items) = model.content {
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(index: model.progressIndex,
                                         total: model.total,
                                         title: title,
                                         subtitle: "What Era unlocks for you",
                                         progressLabel: model.progressLabel)

                EraSurfaceCard {
                    VStack(spacing: 20) {
                        ForEach(items) { row in
                            HStack(alignment: .top, spacing: 16) {
                                Circle()
                                    .fill(themeManager.primary.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: row.icon)
                                            .foregroundColor(themeManager.primary)
                                            .font(.system(size: 18, weight: .semibold))
                                    )

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(row.title)
                                        .font(.headline)
                                        .foregroundColor(themeManager.textPrimary)
                                    Text(row.description)
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textSecondary)
                                }

                                Spacer()
                            }
                            
                            if row.id != items.last?.id {
                                Divider()
                                    .background(Color.black.opacity(0.05))
                            }
                        }
                    }
                }

                Spacer()

                Button("Continue", action: action)
                    .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
    }
}
