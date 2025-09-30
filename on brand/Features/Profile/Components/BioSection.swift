//
//  BioSection.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI

struct BioSection: View {
    let userArchetype: Archetype
    let selectedContentTab: ContentTab
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) { // Fixed spacing for stability
            if selectedContentTab == .hashtag {
                // Instagram style bio
                Text("Pierson")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("nyc")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                Button(action: {
                    if let url = URL(string: "https://instagram.com/piersonrdavis") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("instagram.com/piersonrdavis")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            } else {
                // Vibe profile bio
                Text(userArchetype.title.uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(userArchetype.blurb)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                
                Text(userArchetype.analysis)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 120) // Fixed minimum height to prevent layout shifts
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
