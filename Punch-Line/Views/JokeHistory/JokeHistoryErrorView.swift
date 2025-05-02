//
//  JokeHistoryErrorView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 5/2/25.
//

import SwiftUI

struct JokeHistoryErrorView: View {
    
    var body: some View {
        ZStack {
            StyleManager.generateRandomBackgroundColor()
                .ignoresSafeArea(edges: [.top])
            VStack(alignment: .center) {
                Text("This Punch-Line has no history.  Is it too new perhaps?  Go submit some jokes to it! - Jeff")
                    .font(Font.system(size: 24.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
            }
            .padding([.horizontal], 16.0)
            .navigationTitle(NavigationTitles.entertainmentError)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(ImageTitles.iconNavigationTitle)
                        .foregroundStyle(.accent)
                }
            }
        }
    }
    
}

#Preview {
    JokeHistoryErrorView()
}
