//
//  InstagramContentTabs.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import SwiftUI

struct InstagramContentTabs: View {
    @Binding var selectedContentTab: ContentTab
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 0) {
            // Vibe Profile tab (left)
            Button(action: {
                selectedContentTab = .profile
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(selectedContentTab == .profile ? themeManager.textPrimary : themeManager.tabBarInactive)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(selectedContentTab == .profile ? themeManager.textPrimary : Color.clear)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
            }
            
            // Instagram Posts tab (right)
            Button(action: {
                selectedContentTab = .hashtag
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(selectedContentTab == .hashtag ? themeManager.textPrimary : themeManager.tabBarInactive)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(selectedContentTab == .hashtag ? themeManager.textPrimary : Color.clear)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
            }
        }
        .padding(.horizontal, 16)
        .background(themeManager.backgroundTop)
    }
}
