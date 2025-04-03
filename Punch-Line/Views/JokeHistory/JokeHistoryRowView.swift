//
//  JokeHistoryRowView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/2/25.
//

import SwiftUI

struct JokeHistoryRowView: View {

    let rowTitle: String

    var body: some View {
        HStack {
            Spacer()
            Text(rowTitle)
                .font(Font.system(size: 24.0, weight: .bold))
                .foregroundStyle(.accent)
                .padding([.vertical], 16.0)
            Spacer()
        }
    }
    
}
