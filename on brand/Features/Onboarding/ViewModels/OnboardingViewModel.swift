//
//  OnboardingViewModel.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import Foundation
import SwiftUI
// import FirebaseAuth
// import FirebaseCore

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published private(set) var currentScreenIndex: Int = 0
    @Published private(set) var answers: [QuizQuestion.ID: Int] = [:]
    @Published var finished: Bool = false
    @Published var selectedGender: Gender?
    @Published var userName: String = ""
    
    // Theme manager for dynamic theming

    private(set) var primaryArchetype: Archetype?
    private(set) var secondaryArchetype: Archetype?

    private(set) var currentQuestionSet: OnboardingQuestionSet
    private(set) var questions: [QuizQuestion]
    private var questionIndexMap: [QuizQuestion.ID: Int]
    private(set) var screens: [OnboardingScreen]
    
    // Lazy loading for better performance
    private var _screens: [OnboardingScreen]?
    private var screensCache: [OnboardingScreen] {
        if let cached = _screens {
            return cached
        }
        // Check if we need name input - only if we don't have a name from Apple
        let needsNameInput = userName.isEmpty || userName == "Era User"
        let built = OnboardingFlowBuilder.makeScreens(from: questions, needsNameInput: needsNameInput, userName: userName)
        _screens = built
        return built
    }

    init(questionSet: OnboardingQuestionSet = .vibeDiscovery) {
        self.currentQuestionSet = questionSet
        self.questions = OnboardingQuestionBank.questions(for: questionSet)
        self.questionIndexMap = Dictionary(uniqueKeysWithValues: questions.enumerated().map { ($0.element.id, $0.offset) })
        self.screens = [] // Will be loaded lazily
        
        // Load user name from UserDefaults (Firebase disabled for now)
        if let storedName = UserDefaults.standard.string(forKey: "user_full_name"), !storedName.isEmpty {
            self.userName = storedName
            print("🔥 OnboardingViewModel: Loaded name from UserDefaults: \(storedName)")
        }
    }
    
    // Clear screen cache when userName changes to rebuild screens with correct name input requirement
    func clearScreenCache() {
        _screens = nil
    }
    
    // Refresh user name from UserDefaults (Firebase disabled for now)
    func refreshUserNameFromUserDefaults() {
        if let storedName = UserDefaults.standard.string(forKey: "user_full_name"), !storedName.isEmpty {
            if self.userName != storedName {
                self.userName = storedName
                print("🔥 OnboardingViewModel: Updated name from UserDefaults: \(storedName)")
                // Clear screen cache to rebuild with new name
                clearScreenCache()
            }
        }
    }

    var currentScreen: OnboardingScreen? {
        let screens = screensCache
        guard screens.indices.contains(currentScreenIndex) else { return nil }
        return screens[currentScreenIndex]
    }

    func advanceScreen() {
        let screens = screensCache
        guard currentScreenIndex + 1 < screens.count else { return }
        
        // Prevent multiple rapid updates by using a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.currentScreenIndex += 1
        }
    }

    func goBackScreen() {
        guard currentScreenIndex > 0 else { return }
        currentScreenIndex -= 1
    }

    func selectedAnswerIndex(for question: QuizQuestion) -> Int? {
        answers[question.id]
    }

    func selectGender(_ gender: Gender) {
        selectedGender = gender
        
        // Update question set based on gender without resetting screen index
        let newQuestionSet: OnboardingQuestionSet = gender == .male ? .maleVibeDiscovery : .femaleVibeDiscovery
        currentQuestionSet = newQuestionSet
        questions = OnboardingQuestionBank.questions(for: newQuestionSet)
        questionIndexMap = Dictionary(uniqueKeysWithValues: questions.enumerated().map { ($0.element.id, $0.offset) })
        _screens = nil // Clear cache to force rebuild with new questions
        
        // Force UI update by triggering objectWillChange
        objectWillChange.send()
        
        // Advance to the next screen
        let screens = screensCache
        if currentScreenIndex + 1 < screens.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.currentScreenIndex += 1
            }
        }
    }

    func selectAnswer(for question: QuizQuestion, optionIndex: Int) {
        guard question.answers.indices.contains(optionIndex) else { return }
        answers[question.id] = optionIndex

        // Advance to the next screen right after an answer is chosen.
        let screens = screensCache
        if currentScreenIndex + 1 < screens.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.currentScreenIndex += 1
            }
        }
    }

    func reset() {
        answers = [:]
        currentScreenIndex = 0
        finished = false
        selectedGender = nil
        userName = ""
        primaryArchetype = nil
        secondaryArchetype = nil
        
        // Clear screen cache to force rebuild
        clearScreenCache()
        
        // Refresh user name from UserDefaults after reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.refreshUserNameFromUserDefaults()
        }
    }

    func completeOnboarding() {
        calculateResults()
        
        // TODO: Save onboarding data to Firebase
        // This will be implemented after adding FirebaseOnboardingService to Xcode project
        
        finished = true
    }

    func makeVibeResult() -> VibeResult {
        VibeResult(
            primary: primaryArchetype ?? Archetype.defaultPrimary,
            secondary: secondaryArchetype,
            description: "Generated from quiz"
        )
    }

    func reload(for questionSet: OnboardingQuestionSet) {
        answers = [:]
        primaryArchetype = nil
        secondaryArchetype = nil
        finished = false
        currentScreenIndex = 0
        currentQuestionSet = questionSet
        questions = OnboardingQuestionBank.questions(for: questionSet)
        questionIndexMap = Dictionary(uniqueKeysWithValues: questions.enumerated().map { ($0.element.id, $0.offset) })
        _screens = nil // Clear cache to force rebuild
    }

    private func calculateResults() {
        var scorecard = QuizScorecard()

        for (questionID, answerIndex) in answers {
            guard let questionPosition = questionIndexMap[questionID], questions.indices.contains(questionPosition) else { continue }
            let question = questions[questionPosition]
            guard question.answers.indices.contains(answerIndex) else { continue }
            scorecard.apply(question.answers[answerIndex].weights)
        }

        let rankedResults = scorecard.top(Archetype.allCases.count).filter { $0.1 > 0 }
        let resultsDict = Dictionary(uniqueKeysWithValues: rankedResults)
        let vibeResult = VibeAnalyzer.analyzeQuizResults(resultsDict)
        
        primaryArchetype = vibeResult.primary
        secondaryArchetype = vibeResult.secondary
    }
}
