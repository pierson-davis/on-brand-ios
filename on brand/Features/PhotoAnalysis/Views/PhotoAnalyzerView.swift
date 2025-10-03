//
//  PhotoAnalyzerView.swift
//  era
//

import SwiftUI
import PhotosUI

struct PhotoAnalyzerView: View {
    let result: VibeResult
    let onLogout: (() -> Void)?
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var uiImages: [UIImage] = []
    @State private var aiChosen: [UIImage] = []
    @State private var isAnalyzing = false
    @State private var analysisResults: [AIImageAnalysisResponse] = []
    @State private var selectedTab: EraBottomNavigationBar.Tab = .home
    @State private var showingProfile = false
    @State private var showingPhotoPicker = false

    private let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        Group {
            if showingProfile {
                InstagramProfileView(userArchetype: result.primary, onDismiss: dismissProfile, onLogout: onLogout)
            } else {
                ZStack {
                    EraBackground().ignoresSafeArea()
                    mainContentView
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .onChange(of: selectedItems) { _, newItems in
                    Task {
                        uiImages = await loadImages(from: newItems)
                        await analyzePhotos()
                    }
                }
                .onChange(of: selectedTab) { _, newTab in
                    handleTabChange(newTab)
                }
                .photosPicker(
                    isPresented: $showingPhotoPicker,
                    selection: $selectedItems,
                    maxSelectionCount: 12,
                    matching: .images
                )
            }
        }
    }
    
    private var mainContentView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    headerSection
                    summaryCard
                    photoPickerSection
                    aiCurationSection
                    saveButton
                    bottomSpacer
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
            }
            
            EraBottomNavigationBar(selectedTab: $selectedTab, userArchetype: result.primary, onAddPhoto: {
                showingPhotoPicker = true
            })
        }
    }
    
    private var headerSection: some View {
        EraTopBar(title: "Vibe lab",
                  subtitle: "Curate photos for \(result.primary.title)")
    }
    
    private var summaryCard: some View {
        VibeSummaryCard(result: result) {
            showingProfile = true
        }
    }
    
    private var photoPickerSection: some View {
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
    
    private var aiCurationSection: some View {
        EraSurfaceCard {
            VStack(alignment: .leading, spacing: 18) {
                EraSectionHeader(title: "AI curation", subtitle: caption)
                
                if isAnalyzing {
                    ProgressView("Analyzing your vibe…")
                        .tint(Color(red: 0.20, green: 0.22, blue: 0.75))
                        .padding(.top, 12)
                } else if aiChosen.isEmpty {
                    Text("Add a few photos and I'll choose the ones that match your vibe the best.")
                        .font(.subheadline)
                        .foregroundColor(Color.black.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    aiSelectedPhotos
                }
                
                refreshButton
            }
        }
    }
    
    private var aiSelectedPhotos: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(aiChosen, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color(red: 0.20, green: 0.22, blue: 0.75).opacity(0.2), lineWidth: 2)
                        )
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var refreshButton: some View {
        Button(action: reAnalyze) {
            Label("Refresh selection", systemImage: "wand.and.stars")
                .font(.subheadline.bold())
        }
        .buttonStyle(EraSecondaryButtonStyle())
        .disabled(uiImages.isEmpty || isAnalyzing)
    }
    
    private var saveButton: some View {
        Button(action: finalizeBoard) {
            Text("Save vibe board")
        }
        .buttonStyle(EraPrimaryButtonStyle())
    }
    
    private var bottomSpacer: some View {
        Spacer()
            .frame(height: 100)
    }
    
    

    private var caption: String {
        if isAnalyzing { return "Analyzing your vibe..." }
        if aiChosen.isEmpty { return "Waiting for inspiration" }
        if !analysisResults.isEmpty {
            let avgScore = analysisResults.map(\.confidenceScore).reduce(0, +) / analysisResults.count
            return "Selected \(aiChosen.count) photos (avg. \(avgScore)% match)"
        }
        return "Chosen shots matched to \(result.primary.title.lowercased())"
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

    private func loadImages(from items: [PhotosPickerItem]) async -> [UIImage] {
        var images: [UIImage] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                images.append(image)
            }
        }
        return images
    }

    private func analyzePhotos() async {
        guard !uiImages.isEmpty else {
            aiChosen = []
            analysisResults = []
            return
        }
        
        isAnalyzing = true
        
        // Simplified analysis for better preview performance
        let selectedImages = Array(uiImages.prefix(5))
        let analysisResults = selectedImages.map { _ in
            AIImageAnalysisResponse(
                confidenceScore: Int.random(in: 70...95),
                analysis: "Mock analysis for \(result.primary.title) vibe",
                suggestions: "Mock suggestions for improvement"
            )
        }
        
        await MainActor.run {
            aiChosen = selectedImages
            self.analysisResults = analysisResults
            isAnalyzing = false
        }
    }

    private func reAnalyze() {
        Task { await analyzePhotos() }
    }

    private func finalizeBoard() {
        // Placeholder action – hook into persistence later.
    }
    
    private func dismissProfile() {
        showingProfile = false
    }
    
    private func handleTabChange(_ tab: EraBottomNavigationBar.Tab) {
        switch tab {
        case .home:
            // Stay on current view (vibe lab) - reset to home tab
            selectedTab = .home
        case .plus:
            showingPhotoPicker = true
            // Reset to home tab after showing photo picker
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                selectedTab = .home
            }
        case .deals:
            // Navigate to deals tab
            selectedTab = .deals
        case .profile:
            showingProfile = true
            // Reset to home tab after showing profile
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                selectedTab = .home
            }
        }
    }
}

// MARK: - Simplified Preview Components

struct PhotoAnalyzerViewPreview: View {
    let result: VibeResult
    
    var body: some View {
        ZStack {
            EraBackground().ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        // Header
                        EraTopBar(title: "Vibe lab", subtitle: "Curate photos for \(result.primary.title)")
                        
                        // Summary Card
                        VibeSummaryCard(result: result) {}
                        
                        // Photo Picker Section
                        EraSurfaceCard {
                            VStack(alignment: .leading, spacing: 18) {
                                EraSectionHeader(title: "Pick your snapshots", subtitle: "Tap to add up to 12 icons of your vibe")
                                
                                // Add photos button
                                HStack {
                                    Label("Add photos", systemImage: "plus")
                                        .font(.headline)
                                    Spacer()
                                    Text("0/12")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(Color.white.opacity(0.6))
                                )
                                
                                // Photo grid placeholder
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                                    ForEach(0..<6) { index in
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1.5)
                                            .frame(height: 120)
                                            .overlay(
                                                Image(systemName: ["sparkles","paintbrush","camera","sun.max"] [index % 4])
                                                    .font(.title2)
                                                    .foregroundColor(Color.gray.opacity(0.5))
                                            )
                                    }
                                }
                            }
                        }
                        
                        // AI Curation Section
                        EraSurfaceCard {
                            VStack(alignment: .leading, spacing: 18) {
                                EraSectionHeader(title: "AI curation", subtitle: "Waiting for inspiration")
                                
                                Text("Add photos to see AI-powered curation")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 20)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                }
                
                // Bottom navigation
                EraBottomNavigationBar(selectedTab: .constant(.home), userArchetype: result.primary, onAddPhoto: nil)
            }
        }
    }
}

