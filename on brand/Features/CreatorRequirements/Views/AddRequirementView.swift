

//
//  AddRequirementView.swift
//  on brand
//
//  This file defines the view for adding new creator requirements.
//  Provides a comprehensive form for creating requirements based on real agreements.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

/// View for adding new creator requirements
struct AddRequirementView: View {
    
    // MARK: - Properties
    
    /// Manager for creator requirements
    @ObservedObject var requirementsManager: CreatorRequirementsManager
    
    /// Theme manager for consistent styling
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Presentation mode for dismissing the view
    @Environment(\.presentationMode) private var presentationMode
    
    /// Current form state
    @State private var requirementType: RequirementType = .instagramPost
    @State private var title = ""
    @State private var description = ""
    @State private var brandName = ""
    @State private var campaignName = ""
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    @State private var priority: RequirementPriority = .medium
    @State private var isMandatory = true
    
    /// Detailed requirements
    @State private var contentRequirements: ContentRequirements?
    @State private var taggingRequirements: TaggingRequirements?
    @State private var linkRequirements: LinkRequirements?
    @State private var hashtagRequirements: HashtagRequirements?
    @State private var assetRequirements: AssetRequirements?
    
    /// Content Requirements Form State
    @State private var selectedContentFormat: ContentFormat = .image
    @State private var minimumPosts: Int = 0
    @State private var maximumPosts: Int = 0
    @State private var selectedResolution: ContentResolution = .instagram
    @State private var customWidth: Int = 1080
    @State private var customHeight: Int = 1080
    @State private var videoDuration: Int = 30
    @State private var messagingGuidelines: String = ""
    @State private var requiredElements: String = ""
    @State private var prohibitedContent: String = ""
    @State private var postingFrequency: PostingFrequency = .oneTime
    @State private var preferredDays: Set<Weekday> = []
    @State private var peakTimes: String = ""
    
    /// Form validation
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    /// AI Email Parser
    @State private var aiEmailParser: AIEmailParser?
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isParsingEmail = false
    @State private var parsingError: String?
    @State private var useAI = false
    
    /// Enhanced AI functionality
    @State private var parsedDeal: CreatorRequirement?
    
    /// Current step in the form
    @State private var currentStep = 0
    private let totalSteps = 3
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Progress Indicator
                progressIndicator
                
                // MARK: - Form Content
                ScrollView {
                    VStack(spacing: 24) {
                        switch currentStep {
                        case 0:
                            basicInfoStep
                        case 1:
                            detailedRequirementsStep
                        case 2:
                            reviewStep
                        default:
                            basicInfoStep
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                
                // MARK: - Navigation Buttons
                navigationButtons
            }
            .navigationTitle("Add Requirement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(themeManager.textSecondary)
                }
            }
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
        .alert("AI Parsing Error", isPresented: .constant(parsingError != nil)) {
            Button("OK") { parsingError = nil }
        } message: {
            Text(parsingError ?? "")
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onAppear {
            // Initialize AI Email Parser with secure configuration
            aiEmailParser = AIEmailParser { message in
                print("AI Parser: \(message)")
            }
        }
        .onChange(of: selectedImage) { _, newImage in
            if let image = newImage {
                parseEmailWithAI(image: image)
            }
        }
    }
    
    // MARK: - Progress Indicator
    
    private var progressIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? themeManager.primary : themeManager.surface)
                    .frame(width: 12, height: 12)
                
                if step < totalSteps - 1 {
                    Rectangle()
                        .fill(step < currentStep ? themeManager.primary : themeManager.surface)
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(themeManager.surface)
    }
    
    // MARK: - Basic Info Step
    
    private var basicInfoStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Basic Information")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            // AI Email Parser Option
            VStack(alignment: .leading, spacing: 12) {
                Text("Add Deal Method")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                VStack(spacing: 12) {
                    // AI Option
                    Button(action: {
                        useAI = true
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("📧 Parse Email with AI")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("Take a photo of your deal email and let AI fill in the details")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            if isParsingEmail {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "arrow.right")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.primary)
                                .shadow(color: themeManager.primary.opacity(0.3), radius: 4, x: 0, y: 2)
                        )
                    }
                    .disabled(isParsingEmail)
                    
                    // AI Parsed Deal Actions (if available)
                    if let deal = parsedDeal {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("AI Parsing Complete!")
                                    .font(.headline)
                                    .foregroundColor(themeManager.textPrimary)
                                Spacer()
                            }
                            
                            Button("Use This Deal") {
                                useParsedDeal(deal)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        .padding()
                        .background(themeManager.cardBackground)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeManager.surfaceOutline, lineWidth: 1)
                        )
                    }
                    
                    // Manual Option
                    Button(action: {
                        useAI = false
                    }) {
                        HStack {
                            Image(systemName: "pencil.and.outline")
                                .font(.title2)
                                .foregroundColor(themeManager.textPrimary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("✏️ Enter Manually")
                                    .font(.headline)
                                    .foregroundColor(themeManager.textPrimary)
                                
                                Text("Fill in the deal details yourself")
                                    .font(.caption)
                                    .foregroundColor(themeManager.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.title3)
                                .foregroundColor(themeManager.textSecondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(themeManager.textSecondary.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            
            // Requirement Type
            VStack(alignment: .leading, spacing: 8) {
                Text("Requirement Type")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                Picker("Type", selection: $requirementType) {
                    ForEach(RequirementType.allCases, id: \.self) { type in
                        HStack {
                            Image(systemName: type.iconName)
                                .foregroundColor(Color(type.color))
                            Text(type.displayName)
                        }
                        .tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.surface)
                )
            }
            
            // Title
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                TextField("Enter requirement title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                TextField("Enter requirement description", text: $description, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
            }
            
            // Brand Name
            VStack(alignment: .leading, spacing: 8) {
                Text("Brand Name")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                TextField("Enter brand name", text: $brandName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Campaign Name
            VStack(alignment: .leading, spacing: 8) {
                Text("Campaign Name (Optional)")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                TextField("Enter campaign name", text: $campaignName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Due Date
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Set Due Date", isOn: $hasDueDate)
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                if hasDueDate {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                }
            }
            
            // Priority
            VStack(alignment: .leading, spacing: 8) {
                Text("Priority")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                Picker("Priority", selection: $priority) {
                    ForEach(RequirementPriority.allCases, id: \.self) { priority in
                        HStack {
                            Circle()
                                .fill(Color(priority.color))
                                .frame(width: 8, height: 8)
                            Text(priority.displayName)
                        }
                        .tag(priority)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Mandatory Toggle
            Toggle("Mandatory Requirement", isOn: $isMandatory)
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
        }
    }
    
    // MARK: - Detailed Requirements Step
    
    private var detailedRequirementsStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Detailed Requirements")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Text("Configure specific requirements based on the type selected")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
            
            // Content Requirements
            if requirementType.hasDeadline {
                contentRequirementsSection
            }
            
            // Tagging Requirements
            if requirementType == .accountTagging || requirementType == .geoTagging {
                taggingRequirementsSection
            }
            
            // Link Requirements
            if requirementType == .promoCode || requirementType == .trackingLink || requirementType == .affiliateLink {
                linkRequirementsSection
            }
            
            // Hashtag Requirements
            if requirementType == .hashtagUsage {
                hashtagRequirementsSection
            }
            
            // Asset Requirements
            if requirementType == .imageAssets || requirementType == .videoAssets || requirementType == .rawFootage {
                assetRequirementsSection
            }
        }
    }
    
    // MARK: - Content Requirements Section
    
    private var contentRequirementsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Content Requirements")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            VStack(spacing: 16) {
                // Content Type and Count
                contentTypeAndCountSection
                
                // Content Format and Quality
                contentFormatAndQualitySection
                
                // Content Guidelines
                contentGuidelinesSection
                
                // Posting Schedule
                postingScheduleSection
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Content Type and Count Section
    
    private var contentTypeAndCountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content Type & Count")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            // Content Format Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Content Format")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                
                Picker("Content Format", selection: $selectedContentFormat) {
                    ForEach(ContentFormat.allCases, id: \.self) { format in
                        Text(format.displayName).tag(format)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Post Count
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Minimum Posts")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    
                    TextField("0", value: $minimumPosts, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Maximum Posts")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    
                    TextField("0", value: $maximumPosts, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
        }
    }
    
    // MARK: - Content Format and Quality Section
    
    private var contentFormatAndQualitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Format & Quality")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            // Resolution Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Resolution")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                
                Picker("Resolution", selection: $selectedResolution) {
                    ForEach(ContentResolution.allCases, id: \.self) { resolution in
                        Text(resolution.displayName).tag(resolution)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // Custom Dimensions (if custom resolution selected)
            if selectedResolution == .custom {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Width")
                            .font(.caption)
                            .foregroundColor(themeManager.textSecondary)
                        
                        TextField("1080", value: $customWidth, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Height")
                            .font(.caption)
                            .foregroundColor(themeManager.textSecondary)
                        
                        TextField("1080", value: $customHeight, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
            }
            
            // Duration (for videos)
            if selectedContentFormat == .video || selectedContentFormat == .reel {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Duration (seconds)")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    
                    TextField("30", value: $videoDuration, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
        }
    }
    
    // MARK: - Content Guidelines Section
    
    private var contentGuidelinesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content Guidelines")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            // Messaging Guidelines
            VStack(alignment: .leading, spacing: 8) {
                Text("Key Messages")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                
                TextField("Enter key messages to include...", text: $messagingGuidelines, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
            }
            
            // Brand Elements
            VStack(alignment: .leading, spacing: 8) {
                Text("Required Brand Elements")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                
                TextField("Logo, hashtags, mentions...", text: $requiredElements, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(2...4)
            }
            
            // Prohibited Content
            VStack(alignment: .leading, spacing: 8) {
                Text("Prohibited Content")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                
                TextField("Content to avoid...", text: $prohibitedContent, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(2...4)
            }
        }
    }
    
    // MARK: - Posting Schedule Section
    
    private var postingScheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Posting Schedule")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            // Posting Frequency
            VStack(alignment: .leading, spacing: 8) {
                Text("Frequency")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                
                Picker("Frequency", selection: $postingFrequency) {
                    ForEach(PostingFrequency.allCases, id: \.self) { frequency in
                        Text(frequency.displayName).tag(frequency)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Preferred Days (if not one-time)
            if postingFrequency != .oneTime {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Preferred Days")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                        ForEach(Weekday.allCases, id: \.self) { day in
                            Button(action: {
                                togglePreferredDay(day)
                            }) {
                                Text(day.displayName.prefix(3))
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(preferredDays.contains(day) ? themeManager.primary : themeManager.surface)
                                    )
                                    .foregroundColor(preferredDays.contains(day) ? .white : themeManager.textSecondary)
                            }
                        }
                    }
                }
            }
            
            // Peak Times
            VStack(alignment: .leading, spacing: 8) {
                Text("Peak Engagement Times")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                
                TextField("e.g., 6-8 PM, 12-2 PM", text: $peakTimes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
    
    // MARK: - Tagging Requirements Section
    
    private var taggingRequirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tagging Requirements")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            // This would be expanded with actual tagging requirement forms
            Text("Tagging requirements configuration will be implemented here")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.surface)
                )
        }
    }
    
    // MARK: - Link Requirements Section
    
    private var linkRequirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Link Requirements")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            // This would be expanded with actual link requirement forms
            Text("Link requirements configuration will be implemented here")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.surface)
                )
        }
    }
    
    // MARK: - Hashtag Requirements Section
    
    private var hashtagRequirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hashtag Requirements")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            // This would be expanded with actual hashtag requirement forms
            Text("Hashtag requirements configuration will be implemented here")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.surface)
                )
        }
    }
    
    // MARK: - Asset Requirements Section
    
    private var assetRequirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Asset Requirements")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            // This would be expanded with actual asset requirement forms
            Text("Asset requirements configuration will be implemented here")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.surface)
                )
        }
    }
    
    // MARK: - Review Step
    
    private var reviewStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Review & Create")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Text("Review your requirement details before creating")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
            
            // Requirement Summary
            VStack(alignment: .leading, spacing: 12) {
                requirementSummaryCard
            }
        }
    }
    
    // MARK: - Requirement Summary Card
    
    private var requirementSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: requirementType.iconName)
                    .font(.title2)
                    .foregroundColor(Color(requirementType.color))
                
                VStack(alignment: .leading) {
                    Text(requirementType.displayName)
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    Text(brandName)
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                }
                
                Spacer()
                
                // Priority Badge
                Circle()
                    .fill(Color(priority.color))
                    .frame(width: 12, height: 12)
            }
            
            // Title and Description
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                if !campaignName.isEmpty {
                    HStack {
                        Text("Campaign:")
                            .font(.caption)
                            .foregroundColor(themeManager.textSecondary)
                        Text(campaignName)
                            .font(.caption)
                            .foregroundColor(themeManager.textPrimary)
                    }
                }
                
                if hasDueDate {
                    HStack {
                        Text("Due Date:")
                            .font(.caption)
                            .foregroundColor(themeManager.textSecondary)
                        Text(dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(themeManager.textPrimary)
                    }
                }
                
                HStack {
                    Text("Priority:")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    Text(priority.displayName)
                        .font(.caption)
                        .foregroundColor(themeManager.textPrimary)
                }
                
                HStack {
                    Text("Mandatory:")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    Text(isMandatory ? "Yes" : "No")
                        .font(.caption)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.backgroundTop)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Navigation Buttons
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if currentStep > 0 {
                Button("Previous") {
                    withAnimation {
                        currentStep -= 1
                    }
                }
                .foregroundColor(themeManager.primary)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeManager.primary, lineWidth: 1)
                )
            }
            
            Spacer()
            
            if currentStep < totalSteps - 1 {
                Button("Next") {
                    withAnimation {
                        currentStep += 1
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(themeManager.primary)
                .cornerRadius(8)
            } else {
                Button("Create Requirement") {
                    createRequirement()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(themeManager.primary)
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(themeManager.surface)
    }
    
    // MARK: - Helper Methods
    
    private func createRequirement() {
        // Validate form
        guard validateForm() else {
            return
        }
        
        // Create content requirements from form data
        let contentReqs = createContentRequirements()
        
        // Create requirement
        let requirement = CreatorRequirement(
            type: requirementType,
            title: title,
            description: description,
            brandName: brandName,
            campaignName: campaignName.isEmpty ? nil : campaignName,
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority,
            isMandatory: isMandatory,
            contentRequirements: contentReqs,
            taggingRequirements: taggingRequirements,
            linkRequirements: linkRequirements,
            hashtagRequirements: hashtagRequirements,
            assetRequirements: assetRequirements
        )
        
        // Add to manager
        requirementsManager.addRequirement(requirement)
        
        // Dismiss view
        presentationMode.wrappedValue.dismiss()
    }
    
    private func validateForm() -> Bool {
        if title.isEmpty {
            validationMessage = "Title is required"
            showingValidationError = true
            return false
        }
        
        if description.isEmpty {
            validationMessage = "Description is required"
            showingValidationError = true
            return false
        }
        
        if brandName.isEmpty {
            validationMessage = "Brand name is required"
            showingValidationError = true
            return false
        }
        
        return true
    }
    
    // MARK: - AI Email Parsing
    
    private func parseEmailWithAI(image: UIImage) {
        guard let parser = aiEmailParser else { return }
        
        isParsingEmail = true
        parsingError = nil
        
        Task {
            do {
                let parsedDeal = await parser.parseDealEmail(from: image)
                
                await MainActor.run {
                    isParsingEmail = false
                    
                        if let deal = parsedDeal {
                            // Convert ParsedDealInfo to CreatorRequirement
                            let creatorRequirement = convertToCreatorRequirement(deal)
                            // Store parsed deal for review
                            self.parsedDeal = creatorRequirement
                        } else {
                            self.handleParsingError(AIEmailParserError.invalidResponse)
                        }
                }
            } catch {
                await MainActor.run {
                    isParsingEmail = false
                    self.handleParsingError(error)
                }
            }
        }
    }
    
    // MARK: - Enhanced AI Helper Methods
    
    private func useParsedDeal(_ deal: CreatorRequirement) {
        // Populate form with parsed deal data
        title = deal.title
        description = deal.description
        brandName = deal.brandName
        campaignName = deal.campaignName ?? ""
        dueDate = deal.dueDate ?? Date()
        hasDueDate = deal.dueDate != nil
        priority = deal.priority
        isMandatory = deal.isMandatory
        
        // Set detailed requirements
        contentRequirements = deal.contentRequirements
        taggingRequirements = deal.taggingRequirements
        linkRequirements = deal.linkRequirements
        hashtagRequirements = deal.hashtagRequirements
        assetRequirements = deal.assetRequirements
        
        // Move to next step
        currentStep = 1
        
        // Clear parsed deal
        parsedDeal = nil
    }
    
    private func handleParsingError(_ error: Error) {
        parsingError = error.localizedDescription
        isParsingEmail = false
    }
    
    private func convertToCreatorRequirement(_ parsedDeal: ParsedDealInfo) -> CreatorRequirement {
        return CreatorRequirement(
            id: UUID(),
            type: .instagramPost, // Default type, could be enhanced to detect from content
            title: parsedDeal.title,
            description: parsedDeal.description,
            brandName: parsedDeal.brand,
            campaignName: parsedDeal.campaign,
            dueDate: parsedDeal.dueDate,
            priority: .medium,
            isMandatory: true,
            contentRequirements: parsedDeal.requirements,
            taggingRequirements: parsedDeal.tagging,
            linkRequirements: parsedDeal.links,
            hashtagRequirements: parsedDeal.hashtags,
            assetRequirements: parsedDeal.assets,
            notes: parsedDeal.compensation
        )
    }
    
    // MARK: - Helper Functions
    
    private func togglePreferredDay(_ day: Weekday) {
        if preferredDays.contains(day) {
            preferredDays.remove(day)
        } else {
            preferredDays.insert(day)
        }
    }
    
    private func createContentRequirements() -> ContentRequirements? {
        // Only create if we have meaningful data
        guard minimumPosts > 0 || maximumPosts > 0 || !messagingGuidelines.isEmpty || !requiredElements.isEmpty else {
            return nil
        }
        
        let dimensions: ContentDimensions?
        if selectedResolution == .custom {
            dimensions = ContentDimensions(width: customWidth, height: customHeight)
        } else {
            // Set default dimensions based on resolution
            switch selectedResolution {
            case .instagram:
                dimensions = ContentDimensions(width: 1080, height: 1080)
            case .story:
                dimensions = ContentDimensions(width: 1080, height: 1920)
            case .hd:
                dimensions = ContentDimensions(width: 1280, height: 720)
            case .fullHd:
                dimensions = ContentDimensions(width: 1920, height: 1080)
            case .fourK:
                dimensions = ContentDimensions(width: 3840, height: 2160)
            case .custom:
                dimensions = ContentDimensions(width: customWidth, height: customHeight)
            }
        }
        
        let duration: TimeInterval?
        if selectedContentFormat == .video || selectedContentFormat == .reel {
            duration = TimeInterval(videoDuration)
        } else {
            duration = nil
        }
        
        let postingSchedule: PostingSchedule?
        if postingFrequency != .oneTime {
            postingSchedule = PostingSchedule(
                frequency: postingFrequency,
                days: Array(preferredDays),
                times: peakTimes.isEmpty ? nil : [peakTimes],
                timeZone: nil,
                specificDates: nil,
                blackoutDates: nil
            )
        } else {
            postingSchedule = nil
        }
        
        return ContentRequirements(
            minimumPosts: minimumPosts > 0 ? minimumPosts : nil,
            maximumPosts: maximumPosts > 0 ? maximumPosts : nil,
            contentFormat: selectedContentFormat,
            duration: duration,
            dimensions: dimensions,
            minimumResolution: selectedResolution,
            fileFormats: nil,
            qualityStandards: nil,
            messagingGuidelines: messagingGuidelines.isEmpty ? nil : [messagingGuidelines],
            visualStyle: nil,
            toneOfVoice: nil,
            dosAndDonts: nil,
            requiredFeatures: nil,
            prohibitedContent: prohibitedContent.isEmpty ? nil : [prohibitedContent],
            requiredElements: requiredElements.isEmpty ? nil : [requiredElements],
            postingSchedule: postingSchedule,
            timeZone: nil,
            peakTimes: peakTimes.isEmpty ? nil : [peakTimes],
            exampleContent: nil,
            referenceContent: nil,
            brandContentLibrary: nil
        )
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Preview

struct AddRequirementView_Previews: PreviewProvider {
    static var previews: some View {
        AddRequirementView(requirementsManager: CreatorRequirementsManager())
            .environmentObject(ThemeManager.shared)
    }
}
