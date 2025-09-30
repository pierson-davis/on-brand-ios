import SwiftUI

struct OnboardingProgressHeader: View {
    var index: Int
    var total: Int
    var title: String
    var subtitle: String?
    var progressLabel: String
    
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 12) {
                ProgressView(value: Double(index), total: Double(max(total, 1)))
                    .tint(themeManager.primary)
                    .scaleEffect(x: 1, y: 1.4, anchor: .center)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(progressLabel)
                    .font(.footnote.bold())
                    .foregroundColor(themeManager.textSecondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(themeManager.textSecondary)
                }
            }
        }
    }
}
