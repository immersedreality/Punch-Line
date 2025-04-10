//
//  SetupView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct SetupView: View {

    let viewModel: PunchLineViewModel
    
    var body: some View {
        Text("SetupView")
    }
    
}

#Preview {
    SetupView(
        viewModel: PunchLineViewModel(
            punchLineID: UUID().uuidString,
            activity: .setup
        )
    )
}
