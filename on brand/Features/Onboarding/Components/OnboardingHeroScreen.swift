import SwiftUI

struct OnboardingHeroScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        if case let .hero(_, title, subtitle, cta) = model.content {
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(index: model.progressIndex,
                                         total: model.total,
                                         title: title,
                                         subtitle: subtitle,
                                         progressLabel: model.progressLabel)

                Spacer(minLength: 12)

                // Use a placeholder system image instead of missing asset
                Image(systemName: "photo.artframe")
                    .font(.system(size: 120))
                    .foregroundColor(themeManager.primary.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .fill(themeManager.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32, style: .continuous)
                                    .stroke(themeManager.surfaceOutline, lineWidth: 1)
                            )
                    )
                    .shadow(color: themeManager.colorScheme == .dark ? Color.clear : Color.black.opacity(0.1), radius: 20, x: 0, y: 10)

                Spacer(minLength: 12)

                Button(cta, action: action)
                    .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        }
    }
}

