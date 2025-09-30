//
//  NameInputView.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct NameInputView: View {
    let model: OnboardingScreen
    @Binding var userName: String
    let onContinue: () -> Void
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var isEditing = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            OnboardingProgressHeader(
                index: model.progressIndex,
                total: model.total,
                title: "Welcome, \(firstName.isEmpty ? "there" : firstName)!",
                subtitle: "We'll use your name to personalize your experience",
                progressLabel: model.progressLabel
            )
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Your name")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                // First Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("First Name")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(themeManager.primary)
                        
                        TextField("Enter first name", text: $firstName)
                            .textFieldStyle(EraTextFieldStyle())
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.words)
                    }
                }
                
                // Last Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Last Name")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(themeManager.primary)
                        
                        TextField("Enter last name", text: $lastName)
                            .textFieldStyle(EraTextFieldStyle())
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.words)
                    }
                }
                
                if firstName.isEmpty && lastName.isEmpty {
                    Text("Apple didn't provide your name, please enter it above")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                        .padding(.top, 4)
                }
            }
            
            Spacer(minLength: 0)
            
            Button("Continue") {
                // Set userName to just the first name, or "Era User" as fallback
                let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                userName = trimmedFirstName.isEmpty ? "Era User" : trimmedFirstName
                onContinue()
            }
            .buttonStyle(EraPrimaryButtonStyle())
            .disabled(firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .onAppear {
            // If we have a name from Apple, parse it into first/last name
            if !userName.isEmpty && userName != "Era User" {
                let nameComponents = userName.split(separator: " ")
                if let first = nameComponents.first {
                    firstName = String(first)
                }
                if nameComponents.count > 1 {
                    lastName = nameComponents.dropFirst().joined(separator: " ")
                }
            }
        }
    }
}

struct EraTextFieldStyle: TextFieldStyle {
    @EnvironmentObject private var themeManager: ThemeManager
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
            .font(.body)
            .foregroundColor(themeManager.textPrimary)
    }
}

