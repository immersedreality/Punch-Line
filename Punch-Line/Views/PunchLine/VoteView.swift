//
//  VoteView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct VoteView: View {

    let viewModel: PunchLineActivityViewModel

    @Binding var isReadyForNextActivity: Bool
    @State private var showingConfirmationDialog = false
    @State private var showingAlert = false

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
            HStack {
                Text(viewModel.currentJoke?.setup ?? "What do you call big ass titties that never go up and never fall down?")
                    .font(Font.system(size: 20.0, weight: .light))
                    .padding([.top], 2.0)
                Spacer()
            }
            HStack {
                Spacer()
                Text(viewModel.currentJoke?.punchline ?? "I am too stupid to know such a thing.")
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .padding([.top], 2.0)
            }
            Spacer()
            Button {
                viewModel.voteOnCurrentJoke(vote: .ha)
                navigateToNextActivity()
            } label: {
                HStack {
                    Spacer()
                    Text("Ha!")
                        .padding([.vertical], 8.0)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .backgroundStyle(.accent)
            Button {
                viewModel.voteOnCurrentJoke(vote: .meh)
                navigateToNextActivity()
            } label: {
                HStack {
                    Spacer()
                    Text("Meh.")
                        .padding([.vertical], 8.0)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .backgroundStyle(.accent)
            Button {
                viewModel.voteOnCurrentJoke(vote: .ugh)
                navigateToNextActivity()
            } label: {
                HStack {
                    Spacer()
                    Text("Ugh...")
                        .padding([.vertical], 8.0)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .backgroundStyle(.accent)
            Button {
                showingConfirmationDialog = true
            } label: {
                Image(systemName: SystemIcons.reportButton)
                    .foregroundStyle(.accent)
                    .padding([.vertical], 8.0)
            }
        }
        .padding([.horizontal], 16.0)
        .confirmationDialog("", isPresented: $showingConfirmationDialog) {
            Button(ConfirmationDialogMessages.flagJokeAsOffensive) {
                viewModel.reportCurrentJoke(for: .offensive)
                navigateToNextActivity()
            }
            Button(ConfirmationDialogMessages.flagJokeAsTooFunny) {
                if viewModel.getTooFunnyReportsCount() < 10 {
                    viewModel.reportCurrentJoke(for: .tooFunny)
                    navigateToNextActivity()
                } else {
                    showingAlert = true
                }
            }
        }
        .alert("Cool It!", isPresented: $showingAlert) {
            Button("Okeydoke") {
            }
        } message: {
            Text("You only get ten Too Funny reports a day! Stop being so easy to please, you dingus!")
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
            VoteView(
                viewModel: PunchLineActivityViewModel(
                    punchLine: MockDataManager.getPreviewPunchLines()[0],
                    activity: .vote,
                    activityDisplayText: ActivityFeedMessages.vote
                ),
                isReadyForNextActivity: $isReadyForNextActivity
            )

        }

    }

    return Preview()
}
