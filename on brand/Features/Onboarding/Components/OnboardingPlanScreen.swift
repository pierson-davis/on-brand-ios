import SwiftUI

struct OnboardingPlanScreen: View {
    let model: OnboardingScreen
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Progress Header
            OnboardingProgressHeader(
                index: model.progressIndex,
                total: model.total,
                title: "Your Personalized Plan",
                subtitle: "Based on your preferences",
                progressLabel: model.progressLabel
            )
            
            Spacer()
            
            // Plan Content
            VStack(spacing: 20) {
                // Plan Icon
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                // Plan Title
                Text("Your Style Journey Awaits")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                // Plan Description
                Text("Based on your preferences, we've created a personalized roadmap to help you discover and refine your unique aesthetic.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Plan Details
                VStack(spacing: 16) {
                    PlanDetailRow(
                        icon: "camera.fill",
                        title: "Photo Analysis",
                        description: "AI-powered style assessment"
                    )
                    
                    PlanDetailRow(
                        icon: "paintpalette.fill",
                        title: "Color Palette",
                        description: "Personalized color recommendations"
                    )
                    
                    PlanDetailRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Progress Tracking",
                        description: "Monitor your style evolution"
                    )
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Continue Button
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct PlanDetailRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    OnboardingPlanScreen(
        model: OnboardingScreen(
            progressIndex: 1,
            total: 5,
            content: .personalizedPlan(name: "John", daysCount: 30)
        ),
        onContinue: {}
    )
}
