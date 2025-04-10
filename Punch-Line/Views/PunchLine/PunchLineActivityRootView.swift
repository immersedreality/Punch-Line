//
//  PunchLineActivityRootView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct PunchLineActivityRootView: View {

    let viewModel: PunchLineActivityViewModel

    @State var isReadyForNextActivity: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.bottom])
                switch viewModel.getCurrentActivity() {
                case .setup:
                    SetupView(viewModel: self.viewModel, isReadyForNextActivity: $isReadyForNextActivity)
                case .punchline:
                    PunchlineView(viewModel: self.viewModel, isReadyForNextActivity: $isReadyForNextActivity)
                case .vote:
                    VoteView(viewModel: self.viewModel, isReadyForNextActivity: $isReadyForNextActivity)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $isReadyForNextActivity) {
                PunchLineActivityView(viewModel: self.viewModel)
            }
        }
    }

}


#Preview {
    PunchLineActivityRootView(
        viewModel: PunchLineActivityViewModel(
            punchLineID: UUID().uuidString,
            activity: .setup
        )
    )
}
