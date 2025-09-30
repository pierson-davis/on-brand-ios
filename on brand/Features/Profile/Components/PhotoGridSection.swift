//
//  PhotoGridSection.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI
import PhotosUI

struct PhotoGridSection: View {
    @Binding var selectedItems: [PhotosPickerItem]
    let uiImages: [UIImage]
    let analysisResults: [AIImageAnalysisResponse]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
            // Add Photo Button
            addPhotoButton
            
            // Uploaded Photos
            ForEach(Array(uiImages.enumerated()), id: \.offset) { index, image in
                photoGridItem(image, index: index)
            }
        }
    }
    
    private var addPhotoButton: some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: 20,
            matching: .images
        ) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.7))
                        Text("Add")
                            .font(.caption)
                            .foregroundColor(.black.opacity(0.7))
                    }
                )
        }
    }
    
    private func photoGridItem(_ image: UIImage, index: Int) -> some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            
            // Instagram-style white square in corner
            VStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                        .cornerRadius(2)
                }
                Spacer()
            }
            .padding(4)
        }
    }
}
