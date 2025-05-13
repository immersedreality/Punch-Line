//
//  PunchLineLaunchersView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/24/25.
//

import SwiftUI

struct PunchLineLaunchersView: View {

    let viewModel: PunchLineLaunchersViewModel

    @State private var showingPunchLineSheet = false
    @State private var showingCreateSheet = false
    @State private var showingUsernameAlert = false
    @State private var showingJoinSheet = false
    @State private var showingSettingsSheet = false
    @State private var showingAddPunchLineDialog = false

    var body: some View {
        NavigationStack {
            List() {
                Section(
                    header: Text("Public")
                        .font(Font.system(size: 20.0, weight: .semibold))
                        .foregroundStyle(.accent)
                ) {
                    ForEach(viewModel.fetchedPublicPunchLines) { punchLine in
                        PunchLineLauncherView(
                            displayName: punchLine.displayName,
                            punchLineOwnerName: nil
                        )
                        .onTapGesture {
                            viewModel.setSelected(publicPunchLine: punchLine)
                            launchPunchLine()
                        }
                    }
                }
                if !viewModel.fetchedPrivatePunchLines.isEmpty {
                    Section(
                        header: Text("Private")
                            .font(Font.system(size: 20.0, weight: .semibold))
                            .foregroundStyle(.accent)
                    ) {
                        ForEach(viewModel.fetchedPrivatePunchLines) { punchLine in
                            PunchLineLauncherView(
                                displayName: punchLine.displayName,
                                punchLineOwnerName: punchLine.owningUsername
                            )
                            .onTapGesture {
                                viewModel.setSelected(privatePunchLine: punchLine)
                                launchPunchLine()
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingPunchLineSheet) {
                if let punchLineActivityViewModel = viewModel.punchLineActivityViewModel {
                    PunchLineActivityRootView(viewModel: punchLineActivityViewModel)
                        .presentationDragIndicator(.visible)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: SystemIcons.addPunchLineButton)
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            showingAddPunchLineDialog = true
                        }
                        .confirmationDialog("", isPresented: $showingAddPunchLineDialog) {
                            Button(ConfirmationDialogMessages.createNewPrivatePunchLine) {
                                if AppSessionManager.userInfo?.punchLineUsername != nil {
                                    showingCreateSheet = true
                                } else {
                                    showingUsernameAlert = true
                                }
                            }
                            Button(ConfirmationDialogMessages.joinPrivatePunchLine) {
                                showingJoinSheet = true
                            }
                        }
                        .sheet(isPresented: $showingCreateSheet) {
                            CreateOrJoinPrivatePunchLineView(viewModel: CreateOrJoinPrivatePunchLineViewModel(mode: .create))
                                .presentationDragIndicator(.visible)
                        }
                        .sheet(isPresented: $showingJoinSheet) {
                            CreateOrJoinPrivatePunchLineView(viewModel: CreateOrJoinPrivatePunchLineViewModel(mode: .join))
                                .presentationDragIndicator(.visible)
                        }
                        .alert(AlertConstants.whoAreYou, isPresented: $showingUsernameAlert) {
                            Button(AlertConstants.okeydoke) {
                            }
                        } message: {
                            Text(AlertConstants.mustEnterUsername)
                        }
                }
                ToolbarItem(placement: .principal) {
                    Image(ImageTitles.iconNavigationTitle)
                        .foregroundStyle(.accent)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: SystemIcons.settingsButton)
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            showingSettingsSheet = true
                        }
                        .sheet(isPresented: $showingSettingsSheet) {
                            SettingsView()
                                .presentationDragIndicator(.visible)
                        }
                }
            }
            .navigationTitle(NavigationTitles.punchLineLaunchers)
            .listRowSpacing(8.0)
        }
    }

    private func launchPunchLine() {
        Task {
            await viewModel.initializePunchLineActivityViewModel()
            showingPunchLineSheet = true
        }
    }

}

struct PunchLineLauncherView: View {

    let displayName: String
    let punchLineOwnerName: String?
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Text(displayName)
                        .font(Font.system(size: 24.0, weight: .bold))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.top], 16.0)
                    Text("Get in the Punch-Line --->")
                        .font(Font.system(size: 24.0, weight: .light))
                        .foregroundStyle(.accent)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        .padding([.bottom], 16.0)
                }
                Spacer()
            }
            if let punchLineOwnerName {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(punchLineOwnerName)
                            .font(Font.system(size: 10.0, weight: .light))
                            .foregroundStyle(.accent)
                            .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    }
                }
            }
        }
        .listRowBackground(StyleManager.generateRandomBackgroundColor())
    }

}

#Preview {
    PunchLineLaunchersView(
        viewModel: PunchLineLaunchersViewModel(
            fetchedPublicPunchLines: MockDataManager.getPreviewPublicPunchLines(),
            fetchedPrivatePunchLines: MockDataManager.getPreviewPrivatePunchLines()
        )
    )
}
