import SwiftUI

struct OnboardingFlowView: View {
    @ObservedObject var vm: OnboardingViewModel

    init(vm: OnboardingViewModel) {
        self.vm = vm
    }

    var body: some View {
        ZStack {
            EraBackground().ignoresSafeArea()

            if let screen = vm.currentScreen {
                screenView(for: screen)
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .move(edge: .leading).combined(with: .opacity)))
            } else {
                // Fallback view when no screen is available
                VStack {
                    Spacer()
                    Text("Loading...")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: vm.currentScreenIndex)
    }

    @ViewBuilder
    private func screenView(for screen: OnboardingScreen) -> some View {
        switch screen.content {
        case .hero:
            OnboardingHeroScreen(model: screen) {
                vm.advanceScreen()
            }

        case .welcome:
            OnboardingWelcomeScreen(model: screen) {
                vm.advanceScreen()
            }

        case .problemStatement:
            OnboardingProblemScreen(model: screen) {
                vm.advanceScreen()
            }

        case .benefits:
            OnboardingChecklistScreen(model: screen) {
                vm.advanceScreen()
            }

        case .nameInput:
            NameInputView(model: screen, userName: $vm.userName) {
                vm.advanceScreen()
            }

        case .genderSelection:
            GenderSelectionView(viewModel: vm)

        case let .question(question):
            OnboardingQuestionScreen(model: screen,
                                     question: question,
                                     onSelect: { index in
                                         vm.selectAnswer(for: question, optionIndex: index)
                                     },
                                     selectedIndex: vm.selectedAnswerIndex(for: question))

        case .personalizedPlan:
            OnboardingPlanScreen(model: screen) {
                vm.advanceScreen()
            }

        case .progressTracking:
            OnboardingProgressTrackingScreen(model: screen) {
                vm.advanceScreen()
            }

        case .habitTracking:
            OnboardingProgressTrackingScreen(model: screen) {
                vm.advanceScreen()
            }

        case .dailyCheckin:
            OnboardingProgressTrackingScreen(model: screen) {
                vm.advanceScreen()
            }

        case .customPlan:
            OnboardingPlanScreen(model: screen) {
                vm.advanceScreen()
            }

        case .progressGraph:
            OnboardingProgressGraphScreen(model: screen) {
                vm.advanceScreen()
            }

        case .permissionRequest:
            OnboardingPermissionScreen(model: screen) {
                vm.advanceScreen()
            }

        case .readyToStart:
            OnboardingSummaryScreen(model: screen) {
                vm.completeOnboarding()
            }

        case .summary:
            OnboardingSummaryScreen(model: screen) {
                vm.completeOnboarding()
            }
        }
    }
}

