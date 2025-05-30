//
//  PunchlineView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct PunchlineView: View {

    @ObservedObject var viewModel: PunchLineActivityViewModel

    @Binding var isReadyForNextActivity: Bool
    @FocusState private var textFieldIsFocused: Bool
    @State private var showingConfirmationAlert = false
    @State private var showingConfirmationDialog = false

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.activityDisplayText)
                    .font(Font.system(size: 32.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 48.0)
                Spacer()
            }
            ScrollView(.vertical) {
                HStack {
                    Text(viewModel.currentSetup?.text ?? "What do you call big ass titties that never go up and never fall down?")
                        .font(Font.system(size: 20.0, weight: .light))
                        .padding([.top], 2.0)
                    Spacer()
                }
                TextField("", text: $viewModel.enteredPunchlineText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .focused($textFieldIsFocused)
                    .submitLabel(.done)
                    .onChange(of: viewModel.enteredPunchlineText) { _, newValue in
                        if newValue.contains("\n") {
                            viewModel.enteredPunchlineText.replace("\n", with: "")
                            if viewModel.textEntryIsValid() {
                                if AppSessionManager.userInfo?.userHasFatFingers == true {
                                    showingConfirmationAlert = true
                                } else {
                                    viewModel.createNewJoke()
                                    navigateToNextActivity()
                                }
                            }
                        }
                    }
                Button {
                    if AppSessionManager.userInfo?.userHasFatFingers == true {
                        showingConfirmationAlert = true
                    } else {
                        viewModel.createNewJoke()
                        navigateToNextActivity()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Done")
                            .padding([.vertical], 8.0)
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .backgroundStyle(.accent)
                .disabled(!viewModel.textEntryIsValid())
                Button {
                    showingConfirmationDialog = true
                } label: {
                    Image(systemName: SystemIcons.reportButton)
                        .foregroundStyle(.accent)
                        .padding([.top], 8.0)
                }
                Spacer()
            }
        }
        .padding([.horizontal], 16.0)
        .onAppear {
            textFieldIsFocused = true
        }
        .confirmationDialog("", isPresented: $showingConfirmationDialog) {
            Button(ConfirmationDialogMessages.flagSetupAsOffensive) {
                viewModel.reportCurrentSetup(for: .offensive)
                navigateToNextActivity()
            }
            Button(ConfirmationDialogMessages.flagSetupAsUnfunny) {
                viewModel.reportCurrentSetup(for: .unfunny)
                navigateToNextActivity()
            }
        }
        .overlay(ActivityTransitionView().opacity(isReadyForNextActivity ? 1 : 0))
        .alert(AlertConstants.youSure, isPresented: $showingConfirmationAlert) {
            Button(AlertConstants.nah) { }
            Button(AlertConstants.yeah) {
                viewModel.createNewJoke()
                navigateToNextActivity()
            }
        } message: {
            Text(AlertConstants.areYouHappyPunchline)
        }
    }

    private func navigateToNextActivity() {
        DispatchQueue.main.async {
            self.isReadyForNextActivity = true
            self.viewModel.setNextActivity()
        }
    }

}

#Preview {
    struct Preview: View {
        @State var isReadyForNextActivity = false

        var body: some View {
            PunchlineView(
                viewModel: PunchLineActivityViewModel(
                    punchLine: MockDataManager.getPreviewPublicPunchLines()[0],
                    activity: .punchline,
                    activityDisplayText: ActivityFeedMessages.punchline,
                    initialSetupBatch: MockDataManager.getMockSetupBatch(),
                    initialJokeBatch: MockDataManager.getMockOrPreviewJokeBatch(numberOfJokes: 50)
                ),
                isReadyForNextActivity: $isReadyForNextActivity
            )

        }

    }

    return Preview()
}
