//
//  PunchLineActivityView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct PunchLineActivityView: View {

    let viewModel: PunchLineActivityViewModel
    let adViewModel: InterstitialAdViewModel

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
                case .somethingWentWrong:
                    SomethingWentWrongView()
                }

            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $isReadyForNextActivity) {
                PunchLineActivityView(viewModel: self.viewModel, adViewModel: self.adViewModel)
            }
            .onAppear {
                if AppSessionManager.shouldShowAd {
                    adViewModel.showAd()
                }
            }
    }

}


#Preview {
    PunchLineActivityView(
        viewModel: PunchLineActivityViewModel(
            punchLine: MockDataManager.getPreviewPunchLines()[0],
            activity: .setup,
            activityDisplayText: ActivityFeedMessages.setupFirst
        ),
        adViewModel: InterstitialAdViewModel()
    )
}
