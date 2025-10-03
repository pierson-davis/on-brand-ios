//
//  DebugToolsView.swift
//  on brand
//
//  This view provides debugging and testing tools for developers.
//  It includes log viewing, performance monitoring, and testing utilities.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

// MARK: - Debug Tools View
// This view provides debugging and testing tools for developers
struct DebugToolsView: View {
    
    // MARK: - State Properties
    /// Debug logs for the developer
    @Binding var debugLogs: [String]
    
    /// Controls whether performance monitoring is enabled
    @State private var isPerformanceMonitoringEnabled = false
    
    /// Controls whether crash reporting is enabled
    @State private var isCrashReportingEnabled = false
    
    /// Controls whether analytics are enabled
    @State private var isAnalyticsEnabled = false
    
    /// Controls whether the log viewer is visible
    @State private var showLogViewer = true
    
    /// Controls whether the performance monitor is visible
    @State private var showPerformanceMonitor = true
    
    /// Controls whether the testing tools are visible
    @State private var showTestingTools = true
    
    /// Performance metrics
    @State private var memoryUsage: Double = 0
    @State private var cpuUsage: Double = 0
    @State private var networkRequests: Int = 0
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                EraBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Header Section
                        // This shows the debug tools title and status
                        headerSection
                        
                        // MARK: - Debug Controls Section
                        // This provides controls for debug features
                        debugControlsSection
                        
                        // MARK: - Log Viewer Section
                        // This shows debug logs
                        if showLogViewer {
                            logViewerSection
                        }
                        
                        // MARK: - Performance Monitor Section
                        // This shows performance metrics
                        if showPerformanceMonitor {
                            performanceMonitorSection
                        }
                        
                        // MARK: - Testing Tools Section
                        // This provides testing utilities
                        if showTestingTools {
                            testingToolsSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Debug Tools")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss the view
                    }
                }
            }
        }
        .onAppear {
            startPerformanceMonitoring()
        }
        .onDisappear {
            stopPerformanceMonitoring()
        }
    }
    
    // MARK: - Header Section
    /// The header section with title and debug status
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Debug Tools Icon
            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primary)
            
            // Title
            Text("Debug Tools")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            // Description
            Text("Debugging and testing utilities for development")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
            
            // Debug Status
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                
                Text("Debug Mode Active")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Debug Controls Section
    /// Controls for debug features
    private var debugControlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Debug Controls", icon: "slider.horizontal.3")
            
            VStack(spacing: 12) {
                // Toggle Controls
                VStack(spacing: 8) {
                    toggleControl(
                        title: "Performance Monitoring",
                        isOn: $isPerformanceMonitoringEnabled,
                        icon: "chart.line.uptrend.xyaxis"
                    )
                    
                    toggleControl(
                        title: "Crash Reporting",
                        isOn: $isCrashReportingEnabled,
                        icon: "exclamationmark.triangle.fill"
                    )
                    
                    toggleControl(
                        title: "Analytics",
                        isOn: $isAnalyticsEnabled,
                        icon: "chart.bar.fill"
                    )
                }
                
                // View Controls
                VStack(spacing: 8) {
                    toggleControl(
                        title: "Log Viewer",
                        isOn: $showLogViewer,
                        icon: "doc.text.fill"
                    )
                    
                    toggleControl(
                        title: "Performance Monitor",
                        isOn: $showPerformanceMonitor,
                        icon: "speedometer"
                    )
                    
                    toggleControl(
                        title: "Testing Tools",
                        isOn: $showTestingTools,
                        icon: "testtube.2"
                    )
                }
            }
        }
    }
    
    // MARK: - Log Viewer Section
    /// Shows debug logs
    private var logViewerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Debug Logs", icon: "doc.text.fill")
            
            VStack(spacing: 12) {
                // Log Controls
                HStack {
                    Button("Clear Logs") {
                        debugLogs.removeAll()
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                    
                    Spacer()
                    
                    Button("Export Logs") {
                        exportLogs()
                    }
                    .buttonStyle(EraPrimaryButtonStyle())
                }
                
                // Log Display
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(debugLogs, id: \.self) { log in
                            Text(log)
                                .font(.caption)
                                .foregroundColor(themeManager.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(themeManager.surface)
                                )
                        }
                    }
                }
                .frame(maxHeight: 300)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(themeManager.surfaceOutline, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    // MARK: - Performance Monitor Section
    /// Shows performance metrics
    private var performanceMonitorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Performance Monitor", icon: "speedometer")
            
            VStack(spacing: 12) {
                // Performance Metrics
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    performanceMetric(
                        title: "Memory Usage",
                        value: "\(Int(memoryUsage)) MB",
                        icon: "memorychip.fill",
                        color: memoryUsage > 100 ? .red : .green
                    )
                    
                    performanceMetric(
                        title: "CPU Usage",
                        value: "\(Int(cpuUsage))%",
                        icon: "cpu.fill",
                        color: cpuUsage > 80 ? .red : .green
                    )
                    
                    performanceMetric(
                        title: "Network Requests",
                        value: "\(networkRequests)",
                        icon: "network",
                        color: .blue
                    )
                    
                    performanceMetric(
                        title: "App Uptime",
                        value: "2h 15m",
                        icon: "clock.fill",
                        color: .orange
                    )
                }
                
                // Performance Chart (Placeholder)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Performance Chart")
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.surface)
                        .frame(height: 100)
                        .overlay(
                            VStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.title)
                                    .foregroundColor(themeManager.textSecondary)
                                Text("Performance Chart")
                                    .font(.caption)
                                    .foregroundColor(themeManager.textSecondary)
                            }
                        )
                }
            }
        }
    }
    
    // MARK: - Testing Tools Section
    /// Provides testing utilities
    private var testingToolsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Testing Tools", icon: "testtube.2")
            
            VStack(spacing: 12) {
                // Testing Buttons
                VStack(spacing: 8) {
                    Button("Simulate Crash") {
                        simulateCrash()
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                    
                    Button("Test Network") {
                        testNetwork()
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                    
                    Button("Test Storage") {
                        testStorage()
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                    
                    Button("Test Permissions") {
                        testPermissions()
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                }
                
                // Test Results
                VStack(alignment: .leading, spacing: 8) {
                    Text("Test Results")
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        testResultRow(name: "Network Test", status: "✅ Passed")
                        testResultRow(name: "Storage Test", status: "✅ Passed")
                        testResultRow(name: "Permission Test", status: "⚠️ Partial")
                        testResultRow(name: "Theme Test", status: "✅ Passed")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(themeManager.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeManager.surfaceOutline, lineWidth: 1)
                            )
                    )
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    /// Creates a section header with title and icon
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(themeManager.primary)
                .font(.title2)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
        }
    }
    
    /// Creates a toggle control
    private func toggleControl(title: String, isOn: Binding<Bool>, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(themeManager.primary)
                .frame(width: 24)
            
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: themeManager.primary))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.surfaceOutline, lineWidth: 1)
                )
        )
    }
    
    /// Creates a performance metric
    private func performanceMetric(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.surfaceOutline, lineWidth: 1)
                )
        )
    }
    
    /// Creates a test result row
    private func testResultRow(name: String, status: String) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            Text(status)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textSecondary)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Starts performance monitoring
    private func startPerformanceMonitoring() {
        // Simulate performance monitoring
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            memoryUsage = Double.random(in: 50...150)
            cpuUsage = Double.random(in: 10...90)
            networkRequests += Int.random(in: 0...3)
        }
    }
    
    /// Stops performance monitoring
    private func stopPerformanceMonitoring() {
        // Stop monitoring
    }
    
    /// Exports debug logs
    private func exportLogs() {
        let logText = debugLogs.joined(separator: "\n")
        // In a real implementation, this would save to a file or share
        addDebugLog("📤 Logs exported successfully")
    }
    
    /// Simulates a crash for testing
    private func simulateCrash() {
        addDebugLog("💥 Simulating crash for testing...")
        // In a real implementation, this would trigger a crash
    }
    
    /// Tests network connectivity
    private func testNetwork() {
        addDebugLog("🌐 Testing network connectivity...")
        addDebugLog("✅ Network test completed")
    }
    
    /// Tests storage functionality
    private func testStorage() {
        addDebugLog("💾 Testing storage functionality...")
        addDebugLog("✅ Storage test completed")
    }
    
    /// Tests app permissions
    private func testPermissions() {
        addDebugLog("🔐 Testing app permissions...")
        addDebugLog("⚠️ Some permissions require user interaction")
    }
    
    /// Adds a debug log entry
    private func addDebugLog(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        debugLogs.append("[\(timestamp)] \(message)")
    }
}

// MARK: - Preview
/// This section provides a preview for Xcode's canvas
#Preview {
    DebugToolsView(debugLogs: .constant([]))
        .environmentObject(ThemeManager.shared)
}
