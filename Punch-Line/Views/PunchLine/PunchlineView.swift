//
//  PunchlineView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct PunchlineView: View {

    let viewModel: PunchLineViewModel
    
    var body: some View {
        Text("PunchlineView")
    }
    
}

#Preview {
    PunchlineView(
        viewModel: PunchLineViewModel(
            punchLineID: UUID().uuidString,
            activity: .punchline
        )
    )
}
