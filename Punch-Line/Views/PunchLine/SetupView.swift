//
//  SetupView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct SetupView: View {

    @StateObject var viewModel: PunchLineActivityViewModel

    @Binding var isReadyForNextActivity: Bool
    @FocusState private var textFieldIsFocused: Bool

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
            TextField("", text: $viewModel.enteredSetupText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .font(Font.system(size: 20.0, weight: .light))
                .focused($textFieldIsFocused)
                .submitLabel(.done)
                .onChange(of: viewModel.enteredSetupText) { _, newValue in
                    if newValue.contains("\n") {
                        viewModel.enteredSetupText.replace("\n", with: "")
                        if viewModel.textEntryIsValid() {
                            viewModel.createNewSetup()
                            navigateToNextActivity()
                        }
                    }
                }
            Button {
                viewModel.createNewSetup()
                navigateToNextActivity()
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
            HStack {
                Text(ActivityFeedMessages.setupEnd)
                    .font(Font.system(size: 16.0, weight: .light))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                Spacer()
            }
            Spacer()
        }
        .padding([.horizontal], 16.0)
        .onAppear {
            textFieldIsFocused = true
        }
    }

    private func navigateToNextActivity() {
        viewModel.setNextActivity()
        isReadyForNextActivity = true
    }
    
}

#Preview {
    struct Preview: View {
        @State var isReadyForNextActivity = false

        var body: some View {
            SetupView(
                viewModel: PunchLineActivityViewModel(
                    punchLine: MockDataManager.getPreviewPunchLines()[0],
                    activity: .setup,
                    activityDisplayText: ActivityFeedMessages.setupFirst
                ),
                isReadyForNextActivity: $isReadyForNextActivity
            )

        }

    }

    return Preview()
}
