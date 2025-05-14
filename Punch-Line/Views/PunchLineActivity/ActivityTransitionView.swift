//
//  ActivityTransitionView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 5/13/25.
//

import SwiftUI

struct ActivityTransitionView: View {
    
    var body: some View {
        ZStack {
            StyleManager.currentActivityBackgroundColor
                .ignoresSafeArea(edges: [.bottom])
            Text("->")
                .font(Font.system(size: 256.0, weight: .semibold))
                .foregroundStyle(.accent)
                .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
        }
    }
}

#Preview {
    ActivityTransitionView()
}
