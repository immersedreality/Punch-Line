//
//  PunchlineView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct PunchlineView: View {

    let viewModel: PunchLineActivityViewModel

    @Binding var isReadyForNextActivity: Bool

    var body: some View {
        Text("PunchlineView")
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
            PunchlineView(
                viewModel: PunchLineActivityViewModel(
                    punchLineID: UUID().uuidString,
                    activity: .punchline
                ),
                isReadyForNextActivity: $isReadyForNextActivity
            )

        }

    }

    return Preview()
}
