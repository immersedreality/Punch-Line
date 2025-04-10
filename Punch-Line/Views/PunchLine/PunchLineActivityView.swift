//
//  PunchLineActivityView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct PunchLineActivityView: View {

    let viewModel: PunchLineViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.bottom])
                NavigationLink {
                    PunchLineActivityView(viewModel:
                                            PunchLineViewModel(
                                                punchLineID: self.viewModel.punchLineID,
                                                activity: self.viewModel.getNextActivity())
                    )
                } label: {
                    switch viewModel.getCurrentActivity() {
                    case .setup:
                        SetupView(viewModel: self.viewModel)
                    case .punchline:
                        PunchlineView(viewModel: self.viewModel)
                    case .vote:
                        VoteView(viewModel: self.viewModel)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }

}


#Preview {
    PunchLineActivityView(
        viewModel: PunchLineViewModel(
            punchLineID: UUID().uuidString,
            activity: .setup
        )
    )
}
