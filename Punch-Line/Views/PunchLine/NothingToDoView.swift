//
//  NothingToDoView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/15/25.
//

import SwiftUI

struct NothingToDoView: View {

    var body: some View {
        VStack(alignment: .center) {
            Text("There's nothing to do in this Punch-Line for now.\n\nTry out a different one and check back in a bit!")
                .font(Font.system(size: 32.0, weight: .semibold))
                .foregroundStyle(.accent)
                .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
        }
        .padding([.horizontal], 16.0)
    }

}

#Preview {
    NothingToDoView()
}
