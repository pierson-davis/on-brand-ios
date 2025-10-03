//
//  ShakeDetector.swift
//  on brand
//
//  This service provides shake gesture detection for toggling developer console.
//  It uses Core Motion to detect device shake gestures with proper sensitivity tuning.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation
import CoreMotion
import SwiftUI

/// Service for detecting device shake gestures
/// Provides configurable sensitivity and advanced debouncing to prevent false triggers
class ShakeDetector: ObservableObject {
    
    // MARK: - Properties
    
    /// Motion manager for detecting device motion
    private let motionManager = CMMotionManager()
    
    /// Queue for motion updates
    private let motionQueue = OperationQueue()
    
    /// Current shake detection state
    @Published var isShakeDetected = false
    
    /// Shake detection sensitivity (0.0 to 1.0, higher = more sensitive)
    private let shakeSensitivity: Double = 0.7
    
    /// Minimum time between shake detections (prevents rapid firing)
    private let debounceInterval: TimeInterval = 2.0
    
    /// Last shake detection time
    private var lastShakeTime: Date = Date.distantPast
    
    /// Shake detection threshold - increased for better accuracy
    private let shakeThreshold: Double = 2.5
    
    /// Callback for shake detection
    private var onShakeDetected: (() -> Void)?
    
    /// Whether shake detection is currently active
    private var isActive = false
    
    // MARK: - Enhanced Debouncing Properties
    
    /// Whether we're currently processing a shake gesture
    private var isProcessingShake = false
    
    /// Number of consecutive high-acceleration readings required
    private let consecutiveReadingsRequired = 3
    
    /// Current count of consecutive high-acceleration readings
    private var consecutiveHighReadings = 0
    
    /// Time window for consecutive readings (in seconds)
    private let consecutiveReadingsWindow: TimeInterval = 0.5
    
    /// Last time we had a high acceleration reading
    private var lastHighReadingTime: Date = Date.distantPast
    
    /// Minimum time between shake gesture completions
    private let gestureCompletionInterval: TimeInterval = 1.5
    
    // MARK: - Initialization
    
    init() {
        setupMotionManager()
    }
    
    deinit {
        stopShakeDetection()
    }
    
    // MARK: - Public Methods
    
    /// Start shake detection with callback
    /// - Parameter onShake: Callback to execute when shake is detected
    func startShakeDetection(onShake: @escaping () -> Void) {
        guard !isActive else { return }
        
        onShakeDetected = onShake
        isActive = true
        
        // Start accelerometer updates
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1 // 10Hz update rate
            motionManager.startAccelerometerUpdates(to: motionQueue) { [weak self] (data, error) in
                self?.processAccelerometerData(data, error: error)
            }
        }
    }
    
    /// Stop shake detection
    func stopShakeDetection() {
        guard isActive else { return }
        
        isActive = false
        motionManager.stopAccelerometerUpdates()
        onShakeDetected = nil
    }
    
    /// Check if shake detection is currently active
    var isShakeDetectionActive: Bool {
        return isActive
    }
    
    // MARK: - Private Methods
    
    /// Setup motion manager configuration
    private func setupMotionManager() {
        motionQueue.maxConcurrentOperationCount = 1
        motionQueue.name = "ShakeDetectionQueue"
    }
    
    /// Process accelerometer data to detect shake gestures with enhanced debouncing
    /// - Parameters:
    ///   - data: Accelerometer data
    ///   - error: Any error that occurred
    private func processAccelerometerData(_ data: CMAccelerometerData?, error: Error?) {
        guard let data = data, error == nil else {
            print("ShakeDetector: Error processing accelerometer data: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        // Calculate acceleration magnitude
        let acceleration = sqrt(pow(data.acceleration.x, 2) + 
                               pow(data.acceleration.y, 2) + 
                               pow(data.acceleration.z, 2))
        
        let currentTime = Date()
        
        // Check if we're already processing a shake gesture
        if isProcessingShake {
            return
        }
        
        // Check if acceleration exceeds threshold
        if acceleration > shakeThreshold {
            // Check if we're within the consecutive readings window
            if currentTime.timeIntervalSince(lastHighReadingTime) <= consecutiveReadingsWindow {
                consecutiveHighReadings += 1
            } else {
                // Reset counter if too much time has passed
                consecutiveHighReadings = 1
            }
            
            lastHighReadingTime = currentTime
            
            // Debug logging for high acceleration readings
            if consecutiveHighReadings == 1 {
                print("🔧 ShakeDetector: High acceleration detected (\(String(format: "%.2f", acceleration))), starting consecutive count")
            } else {
                print("🔧 ShakeDetector: Consecutive high reading \(consecutiveHighReadings)/\(consecutiveReadingsRequired)")
            }
            
            // Check if we have enough consecutive readings
            if consecutiveHighReadings >= consecutiveReadingsRequired {
                // Check if enough time has passed since last shake gesture
                if currentTime.timeIntervalSince(lastShakeTime) >= gestureCompletionInterval {
                    // Mark as processing to prevent multiple triggers
                    isProcessingShake = true
                    lastShakeTime = currentTime
                    consecutiveHighReadings = 0
                    
                    print("🔧 ShakeDetector: Shake gesture confirmed, triggering callback")
                    
                    // Trigger shake detection on main thread
                    DispatchQueue.main.async { [weak self] in
                        self?.handleShakeDetected()
                    }
                    
                    // Reset processing flag after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.isProcessingShake = false
                        print("🔧 ShakeDetector: Processing flag reset")
                    }
                } else {
                    print("🔧 ShakeDetector: Shake gesture detected but too soon after last gesture")
                }
            }
        } else {
            // Reset consecutive readings if acceleration is below threshold
            if currentTime.timeIntervalSince(lastHighReadingTime) > consecutiveReadingsWindow {
                if consecutiveHighReadings > 0 {
                    print("🔧 ShakeDetector: Resetting consecutive readings (acceleration below threshold)")
                }
                consecutiveHighReadings = 0
            }
        }
    }
    
    /// Handle shake detection event
    private func handleShakeDetected() {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("🔧 [\(timestamp)] ShakeDetector: Shake gesture detected and processed")
        
        isShakeDetected = true
        onShakeDetected?()
        
        // Reset shake detected state after a brief moment
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.isShakeDetected = false
        }
    }
}

// MARK: - Shake Detection View Modifier

/// View modifier for adding shake detection to any SwiftUI view
struct ShakeDetectionModifier: ViewModifier {
    @StateObject private var shakeDetector = ShakeDetector()
    let onShake: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                shakeDetector.startShakeDetection(onShake: onShake)
            }
            .onDisappear {
                shakeDetector.stopShakeDetection()
            }
    }
}

// MARK: - View Extension

extension View {
    /// Add shake detection to any view
    /// - Parameter onShake: Callback to execute when shake is detected
    /// - Returns: Modified view with shake detection
    func onShake(perform onShake: @escaping () -> Void) -> some View {
        self.modifier(ShakeDetectionModifier(onShake: onShake))
    }
}

// MARK: - Haptic Feedback

/// Provides haptic feedback for shake gestures
class ShakeHapticFeedback {
    
    /// Light haptic feedback for shake detection
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    /// Medium haptic feedback for shake detection
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    /// Heavy haptic feedback for shake detection
    static func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    /// Success haptic feedback for developer console toggle
    static func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    /// Warning haptic feedback for developer console toggle
    static func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
}
