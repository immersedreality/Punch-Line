//
//  PunchLineActivityView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct PunchLineActivityView: View {

    let viewModel: PunchLineActivityViewModel

    @State var isReadyForNextActivity: Bool = false
    
    var body: some View {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.bottom])
                switch viewModel.activity {
                case .setup:
                    SetupView(viewModel: self.viewModel, isReadyForNextActivity: $isReadyForNextActivity)
                case .punchline:
                    PunchlineView(viewModel: self.viewModel, isReadyForNextActivity: $isReadyForNextActivity)
                case .vote:
                    VoteView(viewModel: self.viewModel, isReadyForNextActivity: $isReadyForNextActivity)
                case .nothingToDo:
                    NothingToDoView()
                }

            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $isReadyForNextActivity) {
                PunchLineActivityView(viewModel: self.viewModel)
            }
    }

}


#Preview {
    PunchLineActivityView(
        viewModel: PunchLineActivityViewModel(
            punchLine: TestDataManager.testPunchLines[0],
            activity: .setup,
            activityDisplayText: ActivityFeedMessages.setupFirst
        )
    )
}
