//
//  ProfileBioSection.swift
//  on brand
//
//  This component displays the user's bio information including
//  their name, bio text, and any additional profile details.
//  It's designed to look like Instagram's bio section.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Profile Bio Section
// This component creates the bio section that appears below the profile header
struct ProfileBioSection: View {
    
    // MARK: - Properties
    /// The user's primary style archetype (used for display and styling)
    let userArchetype: Archetype
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - Display Name
            // This shows the user's display name (usually their real name)
            Text(userArchetype.title)
                .font(.headline) // Prominent font size
                .fontWeight(.semibold) // Slightly bold for emphasis
                .foregroundColor(themeManager.textPrimary) // Use theme color
            
            // MARK: - Bio Text
            // This shows the user's bio/description text
            Text(bioText)
                .font(.body) // Standard body font
                .foregroundColor(themeManager.textPrimary) // Use theme color
                .lineLimit(nil) // Allow multiple lines
                .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
            
            // MARK: - Additional Info
            // This shows any additional profile information
            additionalInfoSection
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
        .padding(.horizontal, 16) // Add horizontal padding
        .padding(.vertical, 12) // Add vertical padding
        .background(themeManager.surface) // Use theme background color
    }
    
    // MARK: - Bio Text
    // This computed property returns the bio text based on the user's archetype
    private var bioText: String {
        switch userArchetype {
        case .mainCharacter:
            return "✨ Living my main character energy ✨\n\nEvery day is a new chapter in my story. I believe in embracing who you are and expressing it through your style. Fashion is my way of telling the world who I am without saying a word.\n\n#MainCharacter #StyleStory #AuthenticMe"
            
        case .minimalistMaven:
            return "Less is more ✨\n\nI believe in the power of simplicity. Clean lines, neutral tones, and quality pieces that stand the test of time. My style is about intentional choices and mindful consumption.\n\n#Minimalist #SustainableFashion #QualityOverQuantity"
            
        case .vintageVibes:
            return "Vintage soul in a modern world 🌹\n\nI find beauty in the past and bring it into the present. From 70s flares to 90s grunge, every era has something special to offer. My style is a love letter to fashion history.\n\n#Vintage #Retro #FashionHistory"
            
        case .streetSage:
            return "Street culture is my heartbeat 🏙️\n\nBorn from the streets, built for the city. My style is raw, authentic, and unapologetically me. From sneakers to hoodies, I wear my attitude on my sleeve.\n\n#Streetwear #Urban #Authentic"
            
        case .dreamyMuse:
            return "Free spirit, wild heart 🌿\n\nI dance to the rhythm of my own drum. Flowing fabrics, earthy tones, and a touch of wanderlust define my style. Life is too short to blend in.\n\n#DreamyMuse #FreeSpirit #Wanderlust"
            
        case .chicRebel:
            return "Classic with a twist 👔\n\nI believe in timeless style with a modern edge. Clean cuts, quality fabrics, and attention to detail. Chic doesn't mean boring - it means sophisticated.\n\n#ChicRebel #Classic #Sophisticated"
            
        case .boldRebel:
            return "Dark side of style 🖤\n\nI embrace the unconventional and celebrate the alternative. Black is my canvas, attitude is my brush. My style is a statement, not a question.\n\n#BoldRebel #Alternative #Bold"
            
        case .sereneSoul:
            return "Love is in the details 💕\n\nI believe in the power of femininity and the beauty of softness. Lace, florals, and delicate details make my heart skip a beat. Romance isn't dead - it's in my closet.\n\n#SereneSoul #Feminine #Delicate"
            
        case .adventureSeeker:
            return "Performance meets style 💪\n\nI'm always ready for action, whether it's a workout or a night out. My style is functional, comfortable, and always on point. Fitness is my lifestyle, not just my hobby.\n\n#AdventureSeeker #Active #Performance"
            
        case .creativeGenius:
            return "Art is my language 🎨\n\nI express myself through bold choices and creative combinations. My style is my canvas, and every outfit is a masterpiece. Life is too short for boring clothes.\n\n#CreativeGenius #Creative #Bold"
            
        case .techTitan:
            return "Professional with personality 💼\n\nI believe you can be successful and stylish. My work wardrobe is powerful, polished, and perfectly tailored. Confidence is my best accessory.\n\n#TechTitan #Professional #Confident"
            
        case .cozyChic:
            return "Comfort is key 😌\n\nI believe in looking good while feeling great. My style is relaxed, effortless, and always put together. Life's too short to be uncomfortable.\n\n#CozyChic #Comfortable #Effortless"
            
        default:
            return "Discovering my style journey ✨\n\nEvery day is a new opportunity to express who I am through what I wear. Style is personal, evolving, and uniquely mine.\n\n#StyleJourney #SelfExpression #Authentic"
        }
    }
    
    // MARK: - Additional Info Section
    // This creates the additional information section below the bio
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            // MARK: - Website Link
            // This shows the user's website or social media link
            // Note: Website property will be added to Archetype model in future update
            /*
            if let website = userArchetype.website {
                Link(website, destination: URL(string: website) ?? URL(string: "https://example.com")!)
                    .font(.caption) // Small font size
                    .foregroundColor(themeManager.primary) // Use theme color for links
            }
            */
            
            // MARK: - Location
            // This shows the user's location
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.caption) // Small icon
                    .foregroundColor(themeManager.textSecondary) // Secondary color
                
                Text("San Francisco, CA") // TODO: Replace with actual location
                    .font(.caption) // Small font
                    .foregroundColor(themeManager.textSecondary) // Secondary color
            }
            
            // MARK: - Join Date
            // This shows when the user joined the app
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .font(.caption) // Small icon
                    .foregroundColor(themeManager.textSecondary) // Secondary color
                
                Text("Joined January 2025") // TODO: Replace with actual join date
                    .font(.caption) // Small font
                    .foregroundColor(themeManager.textSecondary) // Secondary color
            }
        }
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 0) {
        ProfileBioSection(userArchetype: .mainCharacter)
        ProfileBioSection(userArchetype: .minimalistMaven)
    }
    .environmentObject(ThemeManager.shared)
}
