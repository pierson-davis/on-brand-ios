//
//  PhotoPickerSection.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI
import PhotosUI

struct PhotoPickerSection: View {
    @Binding var selectedItems: [PhotosPickerItem]
    let uiImages: [UIImage]
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        EraSurfaceCard {
            VStack(alignment: .leading, spacing: 18) {
                EraSectionHeader(title: "Pick your snapshots", subtitle: "Tap to add up to 12 icons of your vibe")
                
                photoPickerButton
                photoGrid
            }
        }
    }
    
    private var photoPickerButton: some View {
        PhotosPicker(selection: $selectedItems,
                     maxSelectionCount: 12,
                     matching: .images,
                     photoLibrary: .shared()) {
            HStack {
                Label("Add photos", systemImage: "plus")
                    .font(.headline)
                Spacer()
                Text("\(uiImages.count)/12")
                    .font(.subheadline)
                    .foregroundColor(Color.black.opacity(0.6))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.6))
            )
        }
    }
    
    private var photoGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            if uiImages.isEmpty {
                ForEach(0..<4) { index in
                    placeholderSlot(index: index)
                }
            } else {
                ForEach(Array(uiImages.enumerated()), id: \.offset) { _, image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
            }
        }
    }
    
    private func placeholderSlot(index: Int) -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .strokeBorder(Color.black.opacity(0.05), lineWidth: 1.5)
            .frame(height: 120)
            .overlay(
                Image(systemName: ["sparkles","paintbrush","camera","sun.max"] [index % 4])
                    .font(.title2)
                    .foregroundColor(Color.black.opacity(0.4))
            )
    }
}
