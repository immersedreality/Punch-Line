//
//  PrivatePunchLinesListView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import SwiftUI

struct PrivatePunchLinesListView: View {

    @StateObject var viewModel: PrivatePunchLinesListViewModel

    @State private var showingConfirmationDialog = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.privatePunchLineListBackgroundColor
                    .ignoresSafeArea(edges: [.vertical])
                List(viewModel.privatePunchLines) { privatePunchLine in
                    Button {
                        showingConfirmationDialog = true
                        viewModel.set(selectedPrivatePunchLineID: privatePunchLine.id)
                    } label: {
                        PrivatePunchLineView(privatePunchLine: privatePunchLine)
                    }
                    .confirmationDialog("", isPresented: $showingConfirmationDialog) {
                        switch viewModel.mode {
                        case .owned:
                            Button(ConfirmationDialogMessages.disbandPrivatePunchLine) {
                                viewModel.disbandSelectedPrivatePunchLine()
                            }
                        case .joined:
                            Button(ConfirmationDialogMessages.leavePrivatePunchLine) {
                                viewModel.leaveSelectedPrivatePunchLine()
                            }
                        }
                    }
                }
                .listRowSpacing(8.0)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(viewModel.navigationTitle)
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigateBackToSettings) {
            SettingsView()
        }
    }

}

struct PrivatePunchLineView: View {

    let privatePunchLine: PrivatePunchLine

    var body: some View {
        HStack(spacing: 4.0) {
            HStack {
                Text(privatePunchLine.displayName)
                    .font(Font.system(size: 20.0, weight: .semibold))
                    .foregroundStyle(.accent)
                Spacer()
                Text(privatePunchLine.joinCode)
                    .font(Font.system(size: 20.0, weight: .light))
                    .foregroundStyle(.accent)
            }
        }
    }

}

#Preview {
    PrivatePunchLinesListView(
        viewModel: PrivatePunchLinesListViewModel(mode: .owned)
    )
}
