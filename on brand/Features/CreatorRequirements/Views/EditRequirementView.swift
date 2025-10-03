//
//  EditRequirementView.swift
//  on brand
//
//  This file defines the view for editing existing creator requirements.
//  Provides a form for modifying essential fields of a requirement.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

/// View for editing existing creator requirements
struct EditRequirementView: View {
    
    // MARK: - Properties
    
    /// The requirement to edit
    let requirement: CreatorRequirement
    
    /// Manager for creator requirements
    @ObservedObject var requirementsManager: CreatorRequirementsManager
    
    /// Theme manager for consistent styling
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Presentation mode for dismissing the view
    @Environment(\.presentationMode) private var presentationMode
    
    /// Current form state - initialized with existing requirement data
    @State private var requirementType: RequirementType
    @State private var title: String
    @State private var description: String
    @State private var brandName: String
    @State private var campaignName: String
    @State private var dueDate: Date
    @State private var hasDueDate: Bool
    @State private var priority: RequirementPriority
    @State private var isMandatory: Bool
    @State private var status: RequirementStatus
    @State private var notes: String
    
    /// Form validation
    @State private var showingValidationError = false
    @State private var validationError = ""
    
    /// Loading state
    @State private var isSaving = false
    
    // MARK: - Initialization
    
    init(requirement: CreatorRequirement, requirementsManager: CreatorRequirementsManager) {
        self.requirement = requirement
        self.requirementsManager = requirementsManager
        
        // Initialize all state variables with existing requirement data
        self._requirementType = State(initialValue: requirement.type)
        self._title = State(initialValue: requirement.title)
        self._description = State(initialValue: requirement.description)
        self._brandName = State(initialValue: requirement.brandName)
        self._campaignName = State(initialValue: requirement.campaignName ?? "")
        self._dueDate = State(initialValue: requirement.dueDate ?? Date())
        self._hasDueDate = State(initialValue: requirement.dueDate != nil)
        self._priority = State(initialValue: requirement.priority)
        self._isMandatory = State(initialValue: requirement.isMandatory)
        self._status = State(initialValue: requirement.status)
        self._notes = State(initialValue: requirement.notes ?? "")
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: - Basic Information Section
                Section(header: Text("Basic Information")) {
                    Picker("Type", selection: $requirementType) {
                        ForEach(RequirementType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    
                    TextField("Title", text: $title)
                    
                    TextField("Brand Name", text: $brandName)
                    
                    TextField("Campaign Name", text: $campaignName)
                    
                    ZStack(alignment: .leading) {
                        if description.isEmpty {
                            Text("Description")
                                .foregroundColor(Color(.placeholderText))
                        }
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                    }
                }
                
                // MARK: - Due Date Section
                Section(header: Text("Due Date")) {
                    Toggle("Has Due Date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                // MARK: - Priority & Status Section
                Section(header: Text("Priority & Status")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(RequirementPriority.allCases, id: \.self) { priority in
                            Text(priority.displayName).tag(priority)
                        }
                    }
                    
                    Picker("Status", selection: $status) {
                        ForEach(RequirementStatus.allCases, id: \.self) { status in
                            Text(status.displayName).tag(status)
                        }
                    }
                    
                    Toggle("Mandatory", isOn: $isMandatory)
                }
                
                // MARK: - Notes Section
                Section(header: Text("Notes")) {
                    ZStack(alignment: .leading) {
                        if notes.isEmpty {
                            Text("Add any additional notes...")
                                .foregroundColor(Color(.placeholderText))
                        }
                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                    }
                }
                
                // MARK: - Action Buttons
                Section {
                    Button(action: saveRequirement) {
                        HStack {
                            Spacer()
                            if isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Save Changes")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(isSaving || title.isEmpty || brandName.isEmpty)
                }
            }
            .navigationTitle("Edit Deal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Validation Error", isPresented: $showingValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationError)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Save the edited requirement
    private func saveRequirement() {
        // Validate required fields
        guard !title.isEmpty else {
            validationError = "Please enter a title"
            showingValidationError = true
            return
        }
        
        guard !brandName.isEmpty else {
            validationError = "Please enter a brand name"
            showingValidationError = true
            return
        }
        
        isSaving = true
        
        // Create updated requirement with the same initializer signature as CreatorRequirement
        var updatedRequirement = CreatorRequirement(
            id: requirement.id,
            type: requirementType,
            title: title,
            description: description,
            brandName: brandName,
            campaignName: campaignName.isEmpty ? nil : campaignName,
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority,
            isMandatory: isMandatory,
            contentRequirements: requirement.contentRequirements,
            taggingRequirements: requirement.taggingRequirements,
            linkRequirements: requirement.linkRequirements,
            hashtagRequirements: requirement.hashtagRequirements,
            assetRequirements: requirement.assetRequirements,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Manually set the status property after initialization
        updatedRequirement.status = status
        
        // Update in manager
        requirementsManager.updateRequirement(updatedRequirement)
        
        isSaving = false
        
        // Dismiss view
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview

struct EditRequirementView_Previews: PreviewProvider {
    static var previews: some View {
        EditRequirementView(
            requirement: CreatorRequirement(
                type: .instagramPost,
                title: "Summer Collection Post",
                description: "Post about our new summer collection",
                brandName: "Fashion Brand",
                campaignName: "Summer 2024",
                dueDate: Date(),
                priority: .high,
                isMandatory: true,
                contentRequirements: nil,
                taggingRequirements: nil,
                linkRequirements: nil,
                hashtagRequirements: nil,
                assetRequirements: nil,
                notes: "This is a test requirement"
            ),
            requirementsManager: CreatorRequirementsManager()
        )
        .environmentObject(ThemeManager.shared)
    }
}
