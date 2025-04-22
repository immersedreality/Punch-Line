//
//  CreateOrJoinSuccessView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import SwiftUI

struct CreateOrJoinSuccessView: View {

    var viewModel: CreateOrJoinPrivatePunchLineViewModel

    var body: some View {
        ZStack {
            StyleManager.createOrJoinSuccessBackgroundColor
                .ignoresSafeArea(edges: [.bottom])
            VStack(alignment: .center) {
                Text("swipe down to close")
                    .font(Font.system(size: 16.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.top], 16.0)
                Spacer()
                Text(viewModel.successMessage)
                    .font(Font.system(size: 32.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                Spacer()
            }
            .padding([.horizontal], 16.0)
            .navigationBarBackButtonHidden()
            .onAppear {
                GlobalNotificationManager.shared.shouldRefreshPunchLines = true
            }
        }
    }

}

#Preview {
    CreateOrJoinSuccessView(viewModel: CreateOrJoinPrivatePunchLineViewModel(mode: .create))
}
