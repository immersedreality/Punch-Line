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
            StyleManager.createOrJoinBackgroundColor
                .ignoresSafeArea(edges: [.bottom])
            VStack(alignment: .center) {
                Text(viewModel.successMessage)
                    .font(Font.system(size: 32.0, weight: .semibold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
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
