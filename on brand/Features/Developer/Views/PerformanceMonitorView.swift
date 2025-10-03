//
//  PerformanceMonitorView.swift
//  on brand
//
//  This view provides performance monitoring functionality for developers.
//  It tracks memory usage, CPU usage, network requests, and other metrics.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI
import Foundation

// MARK: - Performance Monitor View
// This view provides performance monitoring functionality for developers
struct PerformanceMonitorView: View {
    
    // MARK: - State Properties
    /// Controls whether monitoring is active
    @State private var isMonitoring = false
    
    /// Memory usage in MB
    @State private var memoryUsage: Double = 0
    
    /// CPU usage percentage
    @State private var cpuUsage: Double = 0
    
    /// Network request count
    @State private var networkRequests: Int = 0
    
    /// App launch time
    @State private var appLaunchTime: Date = Date()
    
    /// Screen refresh rate
    @State private var refreshRate: Double = 60
    
    /// Battery level
    @State private var batteryLevel: Float = 0
    
    /// Available storage space
    @State private var availableStorage: Int64 = 0
    
    /// Performance metrics history
    @State private var metricsHistory: [PerformanceMetric] = []
    
    /// Controls whether the chart is visible
    @State private var showChart = true
    
    /// Controls whether alerts are enabled
    @State private var alertsEnabled = true
    
    /// Performance alerts
    @State private var alerts: [PerformanceAlert] = []
    
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
                        headerSection
                        
                        // MARK: - Monitoring Controls Section
                        monitoringControlsSection
                        
                        // MARK: - Current Metrics Section
                        currentMetricsSection
                        
                        // MARK: - Performance Chart Section
                        if showChart {
                            performanceChartSection
                        }
                        
                        // MARK: - Alerts Section
                        if !alerts.isEmpty {
                            alertsSection
                        }
                        
                        // MARK: - System Info Section
                        systemInfoSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Performance Monitor")
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
            startMonitoring()
        }
        .onDisappear {
            stopMonitoring()
        }
    }
    
    // MARK: - Header Section
    /// The header section with title and monitoring status
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Performance Monitor Icon
            Image(systemName: "speedometer")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primary)
            
            // Title
            Text("Performance Monitor")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            // Description
            Text("Real-time performance monitoring and metrics")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
            
            // Monitoring Status
            HStack {
                Image(systemName: isMonitoring ? "play.circle.fill" : "pause.circle.fill")
                    .foregroundColor(isMonitoring ? .green : .orange)
                
                Text(isMonitoring ? "Monitoring Active" : "Monitoring Paused")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isMonitoring ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isMonitoring ? Color.green.opacity(0.3) : Color.orange.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Monitoring Controls Section
    /// Controls for starting/stopping monitoring
    private var monitoringControlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Monitoring Controls", icon: "slider.horizontal.3")
            
            VStack(spacing: 12) {
                // Start/Stop Monitoring
                Button(action: {
                    if isMonitoring {
                        stopMonitoring()
                    } else {
                        startMonitoring()
                    }
                }) {
                    HStack {
                        Image(systemName: isMonitoring ? "pause.fill" : "play.fill")
                        Text(isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isMonitoring ? Color.red : themeManager.primary)
                    .cornerRadius(12)
                }
                
                // Toggle Controls
                HStack {
                    Toggle("Show Chart", isOn: $showChart)
                        .toggleStyle(SwitchToggleStyle(tint: themeManager.primary))
                    
                    Spacer()
                    
                    Toggle("Alerts", isOn: $alertsEnabled)
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
        }
    }
    
    // MARK: - Current Metrics Section
    /// Shows current performance metrics
    private var currentMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Current Metrics", icon: "chart.bar.fill")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                metricCard(
                    title: "Memory Usage",
                    value: "\(Int(memoryUsage)) MB",
                    icon: "memorychip.fill",
                    color: memoryUsage > 100 ? .red : .green,
                    trend: .up
                )
                
                metricCard(
                    title: "CPU Usage",
                    value: "\(Int(cpuUsage))%",
                    icon: "cpu.fill",
                    color: cpuUsage > 80 ? .red : .green,
                    trend: .stable
                )
                
                metricCard(
                    title: "Network Requests",
                    value: "\(networkRequests)",
                    icon: "network",
                    color: .blue,
                    trend: .up
                )
                
                metricCard(
                    title: "Refresh Rate",
                    value: "\(Int(refreshRate)) FPS",
                    icon: "arrow.clockwise",
                    color: refreshRate < 60 ? .orange : .green,
                    trend: .stable
                )
                
                metricCard(
                    title: "Battery Level",
                    value: "\(Int(batteryLevel * 100))%",
                    icon: "battery.100",
                    color: batteryLevel < 0.2 ? .red : .green,
                    trend: .down
                )
                
                metricCard(
                    title: "Storage",
                    value: "\(availableStorage / 1024 / 1024 / 1024) GB",
                    icon: "internaldrive.fill",
                    color: availableStorage < 1024 * 1024 * 1024 ? .orange : .green,
                    trend: .stable
                )
            }
        }
    }
    
    // MARK: - Performance Chart Section
    /// Shows performance metrics over time
    private var performanceChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Performance Chart", icon: "chart.line.uptrend.xyaxis")
            
            VStack(spacing: 12) {
                // Chart Placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.surface)
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 40))
                                .foregroundColor(themeManager.textSecondary)
                            
                            Text("Performance Chart")
                                .font(.headline)
                                .foregroundColor(themeManager.textPrimary)
                            
                            Text("Memory, CPU, and Network usage over time")
                                .font(.caption)
                                .foregroundColor(themeManager.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    )
                
                // Chart Controls
                HStack {
                    Button("Memory") {
                        // Switch to memory chart
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                    
                    Button("CPU") {
                        // Switch to CPU chart
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                    
                    Button("Network") {
                        // Switch to network chart
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                    
                    Spacer()
                    
                    Button("Clear Data") {
                        metricsHistory.removeAll()
                    }
                    .buttonStyle(EraSecondaryButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Alerts Section
    /// Shows performance alerts
    private var alertsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Performance Alerts", icon: "exclamationmark.triangle.fill")
            
            VStack(spacing: 8) {
                ForEach(alerts, id: \.id) { alert in
                    alertRow(alert: alert)
                }
            }
        }
    }
    
    // MARK: - System Info Section
    /// Shows system information
    private var systemInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "System Info", icon: "info.circle.fill")
            
            VStack(alignment: .leading, spacing: 8) {
                infoRow(title: "App Launch Time", value: DateFormatter.localizedString(from: appLaunchTime, dateStyle: .short, timeStyle: .medium))
                infoRow(title: "Uptime", value: "\(Int(Date().timeIntervalSince(appLaunchTime) / 60)) minutes")
                infoRow(title: "Device Model", value: UIDevice.current.model)
                infoRow(title: "iOS Version", value: UIDevice.current.systemVersion)
                infoRow(title: "Screen Size", value: "\(Int(UIScreen.main.bounds.width))x\(Int(UIScreen.main.bounds.height))")
                infoRow(title: "Screen Scale", value: "\(UIScreen.main.scale)x")
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
    
    /// Creates a metric card
    private func metricCard(title: String, value: String, icon: String, color: Color, trend: TrendDirection) -> some View {
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
            
            // Trend indicator
            HStack(spacing: 4) {
                Image(systemName: trend.icon)
                    .font(.caption2)
                    .foregroundColor(trend.color)
                
                Text(trend.description)
                    .font(.caption2)
                    .foregroundColor(trend.color)
            }
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
    
    /// Creates an alert row
    private func alertRow(alert: PerformanceAlert) -> some View {
        HStack {
            Image(systemName: alert.severity.icon)
                .foregroundColor(alert.severity.color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.title)
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                Text(alert.message)
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            
            Spacer()
            
            Text(alert.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(themeManager.textSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(alert.severity.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(alert.severity.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    /// Creates an info row
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textPrimary)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Starts performance monitoring
    private func startMonitoring() {
        isMonitoring = true
        appLaunchTime = Date()
        
        // Start monitoring timer
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateMetrics()
        }
    }
    
    /// Stops performance monitoring
    private func stopMonitoring() {
        isMonitoring = false
    }
    
    /// Updates performance metrics
    private func updateMetrics() {
        // Simulate metric updates
        memoryUsage = Double.random(in: 50...150)
        cpuUsage = Double.random(in: 10...90)
        networkRequests += Int.random(in: 0...3)
        refreshRate = Double.random(in: 55...60)
        batteryLevel = Float.random(in: 0.1...1.0)
        availableStorage = Int64.random(in: 1024...10240) * 1024 * 1024 * 1024
        
        // Add to history
        let metric = PerformanceMetric(
            timestamp: Date(),
            memoryUsage: memoryUsage,
            cpuUsage: cpuUsage,
            networkRequests: networkRequests
        )
        metricsHistory.append(metric)
        
        // Keep only last 100 metrics
        if metricsHistory.count > 100 {
            metricsHistory.removeFirst()
        }
        
        // Check for alerts
        if alertsEnabled {
            checkForAlerts()
        }
    }
    
    /// Checks for performance alerts
    private func checkForAlerts() {
        if memoryUsage > 120 {
            addAlert(title: "High Memory Usage", message: "Memory usage is above 120MB", severity: .warning)
        }
        
        if cpuUsage > 85 {
            addAlert(title: "High CPU Usage", message: "CPU usage is above 85%", severity: .error)
        }
        
        if batteryLevel < 0.2 {
            addAlert(title: "Low Battery", message: "Battery level is below 20%", severity: .warning)
        }
    }
    
    /// Adds a performance alert
    private func addAlert(title: String, message: String, severity: AlertSeverity) {
        let alert = PerformanceAlert(
            title: title,
            message: message,
            severity: severity,
            timestamp: Date()
        )
        alerts.append(alert)
        
        // Keep only last 10 alerts
        if alerts.count > 10 {
            alerts.removeFirst()
        }
    }
}

// MARK: - Supporting Types

/// Performance metric data
struct PerformanceMetric: Identifiable {
    let id = UUID()
    let timestamp: Date
    let memoryUsage: Double
    let cpuUsage: Double
    let networkRequests: Int
}

/// Performance alert
struct PerformanceAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let severity: AlertSeverity
    let timestamp: Date
}

/// Alert severity levels
enum AlertSeverity {
    case info
    case warning
    case error
    
    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        }
    }
}

/// Trend direction
enum TrendDirection {
    case up
    case down
    case stable
    
    var icon: String {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .stable: return "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return .red
        case .down: return .green
        case .stable: return .blue
        }
    }
    
    var description: String {
        switch self {
        case .up: return "Rising"
        case .down: return "Falling"
        case .stable: return "Stable"
        }
    }
}

// MARK: - Preview
/// This section provides a preview for Xcode's canvas
#Preview {
    PerformanceMonitorView()
        .environmentObject(ThemeManager.shared)
}
