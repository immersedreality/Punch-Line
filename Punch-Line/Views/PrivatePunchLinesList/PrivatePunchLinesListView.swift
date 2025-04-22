//
//  PrivatePunchLinesListView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import SwiftUI

struct PrivatePunchLinesListView: View {

    let viewModel: PrivatePunchLinesListViewModel
    
    @State private var showingConfirmationDialog = false
    @State private var shouldNavigateBackToSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.vertical])
                List(viewModel.privatePunchLines) { privatePunchLine in
                    PrivatePunchLineView(privatePunchLine: privatePunchLine)
                        .onTapGesture {
                            showingConfirmationDialog = true
                            viewModel.set(selectedPrivatePunchLineID: privatePunchLine.id)
                        }
                        .confirmationDialog("", isPresented: $showingConfirmationDialog) {
                            switch viewModel.mode {
                            case .owned:
                                Button(ConfirmationDialogMessages.disbandPrivatePunchLine) {
                                    viewModel.disbandSelectedPrivatePunchLine()
                                    if viewModel.privatePunchLines.isEmpty == true {
                                        shouldNavigateBackToSettings = true
                                    }
                                }
                            case .joined:
                                Button(ConfirmationDialogMessages.leavePrivatePunchLine) {
                                    viewModel.leaveSelectedPrivatePunchLine()
                                    if viewModel.privatePunchLines.isEmpty == true {
                                        shouldNavigateBackToSettings = true
                                    }
                                }

                            }
                        }
                }
                .listRowSpacing(8.0)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(viewModel.navigationTitle)
        }
        .navigationDestination(isPresented: $shouldNavigateBackToSettings) {
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
