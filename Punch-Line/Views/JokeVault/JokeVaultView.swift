//
//  JokeVaultView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

struct JokeVaultView: View {
    var body: some View {
        ZStack {
            StyleManager.generateRandomBackgroundColor()
                .ignoresSafeArea(edges: [.top])
            List {
                JokeVaultDateView()
                JokeVaultDateView()
                JokeVaultDateView()
                JokeVaultDateView()
                JokeVaultDateView()
            }
            .listRowSpacing(8.0)
            .scrollContentBackground(.hidden)
        }
    }
}

struct JokeVaultDateView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Test Date --->")
                    .font(Font.system(size: 24.0, weight: .bold))
                    .foregroundStyle(.accent)
                    .padding([.vertical], 16.0)
            }
            Spacer()
        }
    }
}

#Preview {
    JokeVaultView()
}
