//
//  JokeHistoryPunchLinesView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/3/25.
//

import SwiftUI

struct JokeHistoryPunchLinesView: View {

    let viewModel: JokeHistoryPunchLinesViewModel

    @State private var showingCreateSheet = false
    @State private var showingJoinSheet = false
    @State private var showingSettingsSheet = false
    @State private var showingAddPunchLineDialog = false

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.top])
                List() {
                    Section(
                        header: Text("Public")
                            .font(Font.system(size: 20.0, weight: .semibold))
                            .foregroundStyle(.accent)
                            .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    ) {
                        ForEach(viewModel.fetchedPublicPunchLines) { punchLine in
                            PunchLineHistoryView(
                                viewModel: viewModel,
                                punchLineID: punchLine.id,
                                punchLineDisplayName: punchLine.displayName,
                                punchLineOwnerName: nil
                            )
                        }
                    }
                    if !viewModel.fetchedPrivatePunchLines.isEmpty {
                        Section(
                            header: Text("Private")
                                .font(Font.system(size: 20.0, weight: .semibold))
                                .foregroundStyle(.accent)
                                .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                        ) {
                            ForEach(viewModel.fetchedPrivatePunchLines) { punchLine in
                                PunchLineHistoryView(
                                    viewModel: viewModel,
                                    punchLineID: punchLine.id,
                                    punchLineDisplayName: punchLine.displayName,
                                    punchLineOwnerName: punchLine.owningUsername
                                )
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: SystemIcons.addPunchLineButton)
                            .foregroundStyle(.accent)
                            .onTapGesture {
                                if AppSessionManager.userInfo?.hasPunchLinePro == true {
                                    showingAddPunchLineDialog = true
                                } else {
                                    showingJoinSheet = true
                                }
                            }
                            .confirmationDialog("", isPresented: $showingAddPunchLineDialog) {
                                Button(ConfirmationDialogMessages.createNewPrivatePunchLine) {
                                    showingCreateSheet = true
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
                .navigationTitle(NavigationTitles.jokeHistoryPunchLines)
                .listRowSpacing(8.0)
                .scrollContentBackground(.hidden)
            }
        }
    }

}

struct PunchLineHistoryView: View {

    let viewModel: JokeHistoryPunchLinesViewModel
    let punchLineID: String
    let punchLineDisplayName: String
    let punchLineOwnerName: String?

    var body: some View {
        ZStack {
            HStack {
                NavigationLink {
                    if viewModel.entryGroupsYearCount(for: punchLineID) > 1 {
                        JokeHistoryYearsView(
                            viewModel: JokeHistoryYearsViewModel(
                                punchLineID: punchLineID,
                                entryGroups: viewModel.getSelectedJokeHistoryEntryGroups(for: punchLineID)
                            )
                        )
                    } else if viewModel.entryGroupsMonthCount(for: punchLineID) > 1 {
                        JokeHistoryMonthsView(
                            viewModel: JokeHistoryMonthsViewModel(
                                punchLineID: punchLineID,
                                selectedYear: Calendar.current.component(.year, from: Date()),
                                entryGroups: viewModel.getSelectedJokeHistoryEntryGroups(for: punchLineID)
                            )
                        )
                    } else if let entryGroup = viewModel.getSelectedJokeHistoryEntryGroups(for: punchLineID).first {
                        JokeHistoryEntriesView(
                            viewModel: JokeHistoryEntriesViewModel(
                                jokeHistoryEntryGroup: entryGroup
                            )
                        )
                    } else {
                        JokeHistoryErrorView()
                    }
                } label: {
                    HStack {
                        Spacer()
                        VStack {
                            Text(punchLineDisplayName)
                                .font(Font.system(size: 24.0, weight: .bold))
                                .foregroundStyle(.accent)
                                .padding([.top], 16.0)
                            Text("Best of the Punch-Line")
                                .font(Font.system(size: 24.0, weight: .light))
                                .foregroundStyle(.accent)
                                .padding([.bottom], 16.0)
                        }
                        Spacer()
                    }
                }
            }
            if let punchLineOwnerName {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(punchLineOwnerName)
                            .font(Font.system(size: 12.0, weight: .light))
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }

}

#Preview {
    JokeHistoryPunchLinesView(
        viewModel: JokeHistoryPunchLinesViewModel(
            fetchedPublicPunchLines: MockDataManager.getPreviewPublicPunchLines(),
            fetchedPrivatePunchLines: MockDataManager.getPreviewPrivatePunchLines()
        )
    )
}
