//
//  ScreenshotGenerator.swift
//  on brand
//
//  This service provides screenshot generation functionality for developers.
//  It captures visual screenshots of all app screens in light, dark, and system themes.
//  Based on the screenshot generator implementation guide.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI
import UIKit
import Photos

// MARK: - Screenshot Generator
// This class provides screenshot generation functionality for developers
@MainActor
class ScreenshotGenerator: ObservableObject {
    
    // MARK: - Properties
    /// The size of screenshots to generate (iPhone 15 dimensions)
    private let screenSize = CGSize(width: 393, height: 852)
    
    /// Theme manager for switching themes
    private let themeManager = ThemeManager.shared
    
    /// Debug log callback
    var addDebugLog: ((String) -> Void) = { _ in }
    
    // MARK: - Screenshot Generation
    
    /// Takes a screenshot of a SwiftUI view
    /// - Parameters:
    ///   - view: The SwiftUI view to capture
    ///   - name: The name for the screenshot file
    func takeScreenshot(of view: AnyView, named name: String) async {
        addDebugLog("📸 Taking screenshot: \(name)")
        
        let wrappedView = view.environmentObject(themeManager)
        let hostingController = UIHostingController(rootView: wrappedView)
        hostingController.view.frame = CGRect(origin: .zero, size: screenSize)
        hostingController.view.backgroundColor = UIColor.systemBackground
        
        hostingController.view.layoutIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(size: screenSize)
        let image = renderer.image { context in
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        
        await saveImageToPhotos(image, named: name)
    }
    
    /// Saves an image to the Photos library
    /// - Parameters:
    ///   - image: The image to save
    ///   - name: The name for the image
    private func saveImageToPhotos(_ image: UIImage, named name: String) async {
        // Request photo library access
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if status != .authorized {
            addDebugLog("❌ Photos access not authorized")
            return
        }
        
        // Save to Photos library
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                if let imageData = image.pngData() {
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                    creationRequest.creationDate = Date()
                }
            }) { success, error in
                if success {
                    self.addDebugLog("✅ SUCCESS: Saved \(name) to Photos library")
                } else {
                    self.addDebugLog("❌ ERROR: Failed to save \(name) to Photos: \(error?.localizedDescription ?? "Unknown error")")
                }
                continuation.resume()
            }
        }
    }
    
    /// Tests Photos access
    func testPhotosAccess() async {
        addDebugLog("🧪 Testing Photos access...")
        
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        addDebugLog("📱 Current Photos status: \(status.rawValue)")
        
        switch status {
        case .authorized:
            addDebugLog("✅ Photos access is authorized")
        case .denied, .restricted:
            addDebugLog("❌ Photos access is denied or restricted")
        case .notDetermined:
            addDebugLog("⏳ Photos access not determined - requesting permission...")
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            addDebugLog("📱 New Photos status: \(newStatus.rawValue)")
            if newStatus == .authorized {
                addDebugLog("✅ Photos permission granted!")
            } else {
                addDebugLog("❌ Photos permission denied")
            }
        case .limited:
            addDebugLog("⚠️ Photos access is limited")
        @unknown default:
            addDebugLog("❓ Unknown Photos access status")
        }
    }
}
