//
//  SetupView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct SetupView: View {

    let viewModel: PunchLineActivityViewModel

    @Binding var isReadyForNextActivity: Bool

    var body: some View {
        Text("SetupView")
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
            SetupView(
                viewModel: PunchLineActivityViewModel(
                    punchLineID: UUID().uuidString,
                    activity: .setup
                ),
                isReadyForNextActivity: $isReadyForNextActivity
            )

        }

    }

    return Preview()
}
