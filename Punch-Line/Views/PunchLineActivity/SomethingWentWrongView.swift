//
//  SomethingWentWrongView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/15/25.
//

import SwiftUI

struct SomethingWentWrongView: View {

    var body: some View {
        VStack(alignment: .center) {
            Text("Something went wrong when determining your next activity in this Punch-Line.\n\nTry out a different one and check back in a bit!\n\n(Already did that?  Maybe your network access is borked. Or maybe it's my fault (Jeff's).  Who knows!?)")
                .font(Font.system(size: 24.0, weight: .semibold))
                .foregroundStyle(.accent)
                .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
        }
        .padding([.horizontal], 16.0)
    }

}

#Preview {
    SomethingWentWrongView()
}
