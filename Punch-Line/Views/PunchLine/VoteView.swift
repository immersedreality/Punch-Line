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

    var body: some View {
        Text("VoteView")
            .onTapGesture {
                navigateToNextActivity()
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
                    punchLineID: UUID().uuidString,
                    activity: .vote
                ),
                isReadyForNextActivity: $isReadyForNextActivity
            )

        }

    }

    return Preview()
}
