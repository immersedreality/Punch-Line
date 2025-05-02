//
//  JokeHistoryViewModels.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/26/25.
//

import Foundation

class JokeHistoryPunchLinesViewModel {

    let fetchedPublicPunchLines: [PublicPunchLine]
    let fetchedPrivatePunchLines: [PrivatePunchLine]
    var fetchedJokeHistoryEntryGroups: [String: [JokeHistoryEntryGroup]] = [:]

    init(fetchedPublicPunchLines: [PublicPunchLine], fetchedPrivatePunchLines: [PrivatePunchLine]) {
        self.fetchedPublicPunchLines = fetchedPublicPunchLines
        self.fetchedPrivatePunchLines = fetchedPrivatePunchLines
        fetchJokeHistoryEntryGroups()
    }

    func fetchJokeHistoryEntryGroups() {
        var punchLineIDs: [String] = []

        for punchLine in fetchedPublicPunchLines {
            punchLineIDs.append(punchLine.id)
        }
        for punchLine in fetchedPrivatePunchLines {
            punchLineIDs.append(punchLine.id)
        }

        Task {
            fetchedJokeHistoryEntryGroups = await APIManager.getJokeHistoryEntryGroups(for: punchLineIDs)
        }
    }

    func entryGroupsYearCount(for punchLineID: String) -> Int {
        var yearCount = 0
        var lastCountedYear = 0

        let entryGroupsToCount = fetchedJokeHistoryEntryGroups[punchLineID] ?? []
        for entryGroup in entryGroupsToCount {
            if lastCountedYear != entryGroup.year {
                yearCount += 1
                lastCountedYear = entryGroup.year
            }
        }

        return yearCount
    }

    func entryGroupsMonthCount(for punchLineID: String) -> Int {
        guard entryGroupsYearCount(for: punchLineID) == 1 else { return 0 }

        var monthCount = 0
        var lastCountedMonth = 0

        let entryGroupsToCount = fetchedJokeHistoryEntryGroups[punchLineID] ?? []
        for entryGroup in entryGroupsToCount {
            if lastCountedMonth != entryGroup.month {
                monthCount += 1
                lastCountedMonth = entryGroup.month
            }
        }

        return monthCount
    }

    func getSelectedJokeHistoryEntryGroups(for punchLineID: String) -> [JokeHistoryEntryGroup] {
        return fetchedJokeHistoryEntryGroups[punchLineID] ?? []
    }

}

class JokeHistoryYearsViewModel {

    let punchLineID: String
    let entryGroups: [JokeHistoryEntryGroup]

    init(punchLineID: String, entryGroups: [JokeHistoryEntryGroup]) {
        self.punchLineID = punchLineID
        self.entryGroups = entryGroups
    }

    func getRowData() -> [JokeHistoryRowDataItem] {

        var rowData: [JokeHistoryRowDataItem] = []

        for entryGroup in entryGroups {
            if !rowData.contains(where: { dataItem in
                dataItem.rowTitle == entryGroup.year.description
            }) {
                rowData.append(JokeHistoryRowDataItem(id: UUID().uuidString, rowTitle: entryGroup.year.description, rowValue: entryGroup.year))
            }
        }

        return rowData

    }

}

class JokeHistoryMonthsViewModel {

    let punchLineID: String
    let selectedYear: Int
    let entryGroups: [JokeHistoryEntryGroup]

    init(punchLineID: String, selectedYear: Int, entryGroups: [JokeHistoryEntryGroup]) {
        self.punchLineID = punchLineID
        self.selectedYear = selectedYear
        self.entryGroups = entryGroups
    }

    func getRowData() -> [JokeHistoryRowDataItem] {

        var rowData: [JokeHistoryRowDataItem] = []

        for entryGroup in entryGroups where entryGroup.year == selectedYear {
            if !rowData.contains(where: { dataItem in
                dataItem.rowTitle == entryGroup.displayMonth
            }) {
                rowData.append(JokeHistoryRowDataItem(id: UUID().uuidString, rowTitle: entryGroup.displayMonth, rowValue: entryGroup.month))
            }
        }

        return rowData

    }

    func getSelectedJokeHistoryEntryGroup(selectedMonth: Int) -> JokeHistoryEntryGroup? {
        return entryGroups.first(where: { entryGroup in
            entryGroup.year == selectedYear && entryGroup.month == selectedMonth
        }) ?? nil
    }

}

class JokeHistoryEntriesViewModel: ObservableObject {

    @Published var jokeHistoryEntries: [JokeHistoryEntry] = []

    init(jokeHistoryEntryGroup: JokeHistoryEntryGroup) {
        Task {
            self.jokeHistoryEntries = await getSelectedJokeHistoryEntries(for: jokeHistoryEntryGroup)
        }
    }

    func getSelectedJokeHistoryEntries(for entryGroup: JokeHistoryEntryGroup) async -> [JokeHistoryEntry] {
        let jokeHistoryEntries = await APIManager.getJokeHistoryEntries(for: entryGroup)
        return jokeHistoryEntries
    }

}

struct JokeHistoryRowDataItem: Identifiable {
    let id: String
    let rowTitle: String
    let rowValue: Int
}
