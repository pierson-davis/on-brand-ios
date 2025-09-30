import SwiftUI

struct OnboardingSummaryScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        switch model.content {
        case let .summary(title, body, _, cta):
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(index: model.progressIndex,
                                         total: model.total,
                                         title: title,
                                         subtitle: nil,
                                         progressLabel: model.progressLabel)

                EraSurfaceCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("What's next")
                            .font(.subheadline.bold())
                            .foregroundColor(themeManager.primary)
                        Text(body)
                            .font(.body)
                            .foregroundColor(themeManager.textPrimary)
                    }
                }

                Spacer(minLength: 12)

                Button(cta, action: action)
                    .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            
        case let .readyToStart(name, cta):
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(index: model.progressIndex,
                                         total: model.total,
                                         title: "You're all set, \(name)!",
                                         subtitle: nil,
                                         progressLabel: model.progressLabel)

                EraSurfaceCard {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Welcome to Era")
                            .font(.subheadline.bold())
                            .foregroundColor(themeManager.primary)
                        
                        Text("Your personalized style journey begins now. Era will help you discover your unique aesthetic and create content that truly represents you.")
                            .font(.body)
                            .foregroundColor(themeManager.textPrimary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.purple)
                                Text("AI-powered style analysis")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.textPrimary)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "camera")
                                    .foregroundColor(.blue)
                                Text("Smart photo curation")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.textPrimary)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.green)
                                Text("Progress tracking")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.textPrimary)
                            }
                        }
                        .padding(.top, 8)
                    }
                }

                Spacer(minLength: 12)

                Button(cta, action: action)
                    .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            
        default:
            // This screen should only handle summary and readyToStart
            VStack {
                Text("Error: Unexpected content type")
                    .foregroundColor(themeManager.textPrimary)
                Button("Continue") {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
        }
    }
}

