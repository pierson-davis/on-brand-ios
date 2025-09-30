//
//  Archetype.swift
//  era
//

import SwiftUI

enum Archetype: String, CaseIterable, Identifiable, Codable, Hashable {
    // Female archetypes
    case mainCharacter, cozyChic, boldVisionary, dreamyMuse, mysteryIcon,
         glowGetter, adventureSeeker, playfulSprite, chicRebel,
         nostalgiaVibes, socialButterfly, sereneSoul
    
    // Male archetypes
    case alphaVibe, streetSage, urbanExplorer, minimalistMaven, 
         creativeGenius, techTitan, ruggedGentleman, socialMagnet,
         vintageVibes, zenMaster, boldRebel, charismaticLeader

    var id: String { rawValue }

    var title: String {
        switch self {
        // Female archetypes
        case .mainCharacter: return "Main Character ✨"
        case .cozyChic: return "Cozy Chic ☕"
        case .boldVisionary: return "Bold Visionary 💥"
        case .dreamyMuse: return "Dreamy Muse 🌙"
        case .mysteryIcon: return "Mystery Icon 🕶️"
        case .glowGetter: return "Glow Getter 🌞"
        case .adventureSeeker: return "Adventure Seeker 🌍"
        case .playfulSprite: return "Playful Sprite 🌸"
        case .chicRebel: return "Chic Rebel 🔥"
        case .nostalgiaVibes: return "Nostalgia Vibes 📼"
        case .socialButterfly: return "Social Butterfly 🦋"
        case .sereneSoul: return "Serene Soul 🌊"
        
        // Male archetypes
        case .alphaVibe: return "Alpha Vibe 👑"
        case .streetSage: return "Street Sage 🏙️"
        case .urbanExplorer: return "Urban Explorer 🚶‍♂️"
        case .minimalistMaven: return "Minimalist Maven ⚪"
        case .creativeGenius: return "Creative Genius 🎨"
        case .techTitan: return "Tech Titan 💻"
        case .ruggedGentleman: return "Rugged Gentleman 🧔"
        case .socialMagnet: return "Social Magnet 🧲"
        case .vintageVibes: return "Vintage Vibes 📻"
        case .zenMaster: return "Zen Master 🧘‍♂️"
        case .boldRebel: return "Bold Rebel ⚡"
        case .charismaticLeader: return "Charismatic Leader 🎯"
        }
    }

    var blurb: String {
        switch self {
        // Female archetypes
        case .mainCharacter: return "Cinematic, confident, center-frame energy."
        case .cozyChic: return "Warm, polished, Pinterest-coded mornings."
        case .boldVisionary: return "Fearless color and unapologetic presence."
        case .dreamyMuse: return "Poetic, soft, golden-hour heart."
        case .mysteryIcon: return "Seen. Not decoded. Carry on."
        case .glowGetter: return "Inside-out glow, main-quest energy."
        case .adventureSeeker: return "New horizons, wide-open wonder."
        case .playfulSprite: return "Stickers, sparkle, serotonin."
        case .chicRebel: return "Rules bent — eyeliner sharp."
        case .nostalgiaVibes: return "Grain, film, and golden memories."
        case .socialButterfly: return "Group sparkle: activated."
        case .sereneSoul: return "Ocean-brain. Cloud-heart."
        
        // Male archetypes
        case .alphaVibe: return "Confident, commanding, natural leader energy."
        case .streetSage: return "Urban wisdom, street-smart, authentic vibes."
        case .urbanExplorer: return "City wanderer, always discovering new spots."
        case .minimalistMaven: return "Clean lines, less is more, refined taste."
        case .creativeGenius: return "Artistic soul, innovative, boundary-pushing."
        case .techTitan: return "Digital native, innovation-driven, future-focused."
        case .ruggedGentleman: return "Rough around the edges, heart of gold."
        case .socialMagnet: return "People gravitate to you, natural connector."
        case .vintageVibes: return "Retro soul, timeless style, classic cool."
        case .zenMaster: return "Calm center, mindful, grounded energy."
        case .boldRebel: return "Rule breaker, trend setter, unapologetic."
        case .charismaticLeader: return "Natural charisma, inspiring, magnetic presence."
        }
    }

    var tint: Color {
        switch self {
        // Female archetypes
        case .cozyChic: return .brown
        case .boldVisionary, .chicRebel: return .red
        case .dreamyMuse, .nostalgiaVibes: return .purple
        case .glowGetter: return .yellow
        case .adventureSeeker, .sereneSoul: return .blue
        case .playfulSprite, .socialButterfly: return .pink
        
        // Male archetypes
        case .alphaVibe, .charismaticLeader: return .orange
        case .streetSage, .urbanExplorer: return .gray
        case .minimalistMaven, .zenMaster: return .white
        case .creativeGenius: return .purple
        case .techTitan: return .blue
        case .ruggedGentleman: return .brown
        case .socialMagnet: return .green
        case .vintageVibes: return .yellow
        case .boldRebel: return .red
        
        default: return .gray
        }
    }
    
    var primaryColor: Color {
        return tint
    }
    
    var secondaryColor: Color {
        switch self {
        // Female archetypes
        case .mainCharacter: return .pink
        case .cozyChic: return .brown
        case .boldVisionary: return .orange
        case .dreamyMuse: return .purple
        case .mysteryIcon: return .gray
        case .glowGetter: return .orange
        case .adventureSeeker: return .mint
        case .playfulSprite: return .yellow
        case .chicRebel: return .black
        case .nostalgiaVibes: return .yellow
        case .socialButterfly: return .purple
        case .sereneSoul: return .mint
        
        // Male archetypes
        case .alphaVibe: return .red
        case .streetSage: return .black
        case .urbanExplorer: return .blue
        case .minimalistMaven: return .gray
        case .creativeGenius: return .pink
        case .techTitan: return .cyan
        case .ruggedGentleman: return .orange
        case .socialMagnet: return .purple
        case .vintageVibes: return .brown
        case .zenMaster: return .mint
        case .boldRebel: return .black
        case .charismaticLeader: return .yellow
        }
    }
}
extension Archetype {
    static let all: [Archetype] = Array(Self.allCases)
    static let defaultPrimary: Archetype = .mainCharacter
    
    // Gender-specific archetype collections
    static let femaleArchetypes: [Archetype] = [
        .mainCharacter, .cozyChic, .boldVisionary, .dreamyMuse, .mysteryIcon,
        .glowGetter, .adventureSeeker, .playfulSprite, .chicRebel,
        .nostalgiaVibes, .socialButterfly, .sereneSoul
    ]
    
    static let maleArchetypes: [Archetype] = [
        .alphaVibe, .streetSage, .urbanExplorer, .minimalistMaven,
        .creativeGenius, .techTitan, .ruggedGentleman, .socialMagnet,
        .vintageVibes, .zenMaster, .boldRebel, .charismaticLeader
    ]
    
    var isFemaleArchetype: Bool {
        Self.femaleArchetypes.contains(self)
    }
    
    var isMaleArchetype: Bool {
        Self.maleArchetypes.contains(self)
    }

    var analysis: String {
        switch self {
        // Female archetypes
        case .mainCharacter: return "Center frame, star soundtrack."
        case .cozyChic: return "You thrive in cozy, polished, intentional spaces."
        case .boldVisionary: return "Fearless with color, unapologetically bold."
        case .dreamyMuse: return "Soft and poetic, always chasing golden hour."
        case .mysteryIcon: return "Private, magnetic, and hard to decode."
        case .glowGetter: return "Your glow lights up everything around you."
        case .adventureSeeker: return "Restless spirit, open skies, new horizons."
        case .playfulSprite: return "Playful, carefree, serotonin in human form."
        case .chicRebel: return "You bend the rules with effortless style."
        case .nostalgiaVibes: return "Grounded in memory, retro at heart."
        case .socialButterfly: return "Group sparkle: always the connector."
        case .sereneSoul: return "Grounded, calm, and centered like the ocean."
        
        // Male archetypes
        case .alphaVibe: return "Natural leader, confident energy that commands respect."
        case .streetSage: return "Urban wisdom, authentic street-smart vibes."
        case .urbanExplorer: return "City wanderer, always discovering new urban gems."
        case .minimalistMaven: return "Clean aesthetic, less is more, refined taste."
        case .creativeGenius: return "Artistic soul, innovative, always pushing boundaries."
        case .techTitan: return "Digital native, innovation-driven, future-focused."
        case .ruggedGentleman: return "Rough exterior, heart of gold, authentic charm."
        case .socialMagnet: return "People naturally gravitate to your magnetic energy."
        case .vintageVibes: return "Retro soul, timeless style, classic cool vibes."
        case .zenMaster: return "Calm center, mindful energy, grounded presence."
        case .boldRebel: return "Rule breaker, trend setter, unapologetically bold."
        case .charismaticLeader: return "Natural charisma, inspiring, magnetic presence."
        }
    }
}
