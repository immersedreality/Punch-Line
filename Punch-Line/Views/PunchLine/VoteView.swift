//
//  VoteView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct VoteView: View {

    let viewModel: PunchLineViewModel
    
    var body: some View {
        Text("VoteView")
    }
    
}

#Preview {
    VoteView(
        viewModel: PunchLineViewModel(
            punchLineID: UUID().uuidString,
            activity: .vote
        )
    )
}
