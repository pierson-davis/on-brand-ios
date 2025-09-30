//
//  InstagramTopBar.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import SwiftUI

struct InstagramTopBar: View {
    let onMenuTap: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            // Left side - Back button or empty space
            Spacer()
                .frame(width: 24)
            
            Spacer()
            
            // Center - Username (Instagram style)
            Text("@pierson_davis")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            // Right side - Menu button
            Button(action: onMenuTap) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(themeManager.textPrimary)
            }
            .frame(width: 24)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(themeManager.backgroundTop)
    }
}
