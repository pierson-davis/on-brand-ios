//
//  RecentPhotosSection.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct RecentPhotosSection: View {
    let profile: UserProfile?
    let onViewAll: () -> Void
    let onAddPhoto: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Photos")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("View All", action: onViewAll)
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.20, green: 0.22, blue: 0.75))
            }
            .padding(.horizontal, 24)
            
            if let profile = profile, !profile.photos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(profile.photos.prefix(5)) { photo in
                            PhotoThumbnailView(photo: photo)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(themeManager.subtleText)
                    
                    Text("No photos yet")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Button("Add Your First Photo", action: onAddPhoto)
                        .font(.caption)
                        .foregroundColor(themeManager.primary)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
            }
        }
    }
}

struct PhotoThumbnailView: View {
    let photo: PhotoData
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.black.opacity(0.1))
            .frame(width: 80, height: 80)
            .overlay(
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.1))
            )
    }
}
