//
//  ContentTabsSection.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI

struct ContentTabsSection: View {
    @Binding var selectedContentTab: ContentTab
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 0) {
            // Hashtag tab (left)
            Button(action: {
                selectedContentTab = .hashtag
            }) {
                Image(systemName: "number")
                    .font(.title2)
                    .foregroundColor(selectedContentTab == .hashtag ? .black : .gray)
                    .frame(width: 44, height: 44) // Fixed frame for stability
            }
            .frame(maxWidth: .infinity)
            
            // Profile tab (right)
            Button(action: {
                selectedContentTab = .profile
            }) {
                Image(systemName: "person.crop.rectangle")
                    .font(.title2)
                    .foregroundColor(selectedContentTab == .profile ? .black : .gray)
                    .frame(width: 44, height: 44) // Fixed frame for stability
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 60) // Fixed height to prevent movement
        .background(Color.white)
    }
}
