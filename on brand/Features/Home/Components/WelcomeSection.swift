//
//  WelcomeSection.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct WelcomeSection: View {
    let profile: UserProfile?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let profile = profile {
                Text("Welcome back, \(profile.name)!")
                    .font(.title2.bold())
                    .foregroundColor(themeManager.textPrimary)
            } else {
                Text("Welcome back!")
                    .font(.title2.bold())
                    .foregroundColor(themeManager.textPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
}
