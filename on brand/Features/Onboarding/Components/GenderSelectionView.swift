//
//  GenderSelectionView.swift
//  era
//

import SwiftUI

struct GenderSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Text("Let's personalize your vibe")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textPrimary)
                    .multilineTextAlignment(.center)

                Text("This helps us tailor your experience and archetype recommendations")
                    .font(.body)
                    .foregroundColor(themeManager.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                GenderOptionView(
                    gender: .male,
                    isSelected: viewModel.selectedGender == .male
                ) {
                    viewModel.selectGender(.male)
                }
                
                GenderOptionView(
                    gender: .female,
                    isSelected: viewModel.selectedGender == .female
                ) {
                    viewModel.selectGender(.female)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct GenderOptionView: View {
    let gender: Gender
    let isSelected: Bool
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: gender == .male ? "person.fill" : "person.fill")
                    .font(.title2)
                        .foregroundColor(isSelected ? .white : themeManager.textPrimary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(gender.displayName)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : themeManager.textPrimary)
                    
                    Text(genderDescription)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : themeManager.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? themeManager.primary : themeManager.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? themeManager.primary : themeManager.surfaceOutline, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var genderDescription: String {
        switch gender {
        case .male:
            return "Masculine archetypes and styling"
        case .female:
            return "Feminine archetypes and styling"
        }
    }
}

