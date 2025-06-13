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
    var jokeHistoryEntryGroupsByPunchLineID: [String: [JokeHistoryEntryGroup]] = [:]

    init(fetchedPublicPunchLines: [PublicPunchLine], fetchedPrivatePunchLines: [PrivatePunchLine]) {
        self.fetchedPublicPunchLines = fetchedPublicPunchLines
        self.fetchedPrivatePunchLines = fetchedPrivatePunchLines
        configureJokeHistoryEntryGroups()
    }

    func configureJokeHistoryEntryGroups() {
        for punchLine in fetchedPublicPunchLines {
            jokeHistoryEntryGroupsByPunchLineID[punchLine.id] = punchLine.historyEntryGroups
        }
        for punchLine in fetchedPrivatePunchLines {
            jokeHistoryEntryGroupsByPunchLineID[punchLine.id] = punchLine.historyEntryGroups
        }
    }

    func entryGroupsYearCount(for punchLineID: String) -> Int {
        var yearCount = 0
        var lastCountedYear = 0

        let entryGroupsToCount = jokeHistoryEntryGroupsByPunchLineID[punchLineID] ?? []
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

        let entryGroupsToCount = jokeHistoryEntryGroupsByPunchLineID[punchLineID] ?? []
        for entryGroup in entryGroupsToCount {
            if lastCountedMonth != entryGroup.month {
                monthCount += 1
                lastCountedMonth = entryGroup.month
            }
        }

        return monthCount
    }

    func getSelectedJokeHistoryEntryGroups(for punchLineID: String) -> [JokeHistoryEntryGroup] {
        return jokeHistoryEntryGroupsByPunchLineID[punchLineID] ?? []
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
                dataItem.entryGroup.year.description == entryGroup.year.description
            }) {
                rowData.append(JokeHistoryRowDataItem(id: UUID().uuidString, entryGroup: entryGroup))
            }
        }

        return rowData

    }

}

class JokeHistoryMonthsViewModel: ObservableObject {

    let punchLineID: String
    let selectedYear: Int
    let entryGroups: [JokeHistoryEntryGroup]
    @Published var entriesDictionary: [String: [JokeHistoryEntry]] = [:]

    init(punchLineID: String, selectedYear: Int, entryGroups: [JokeHistoryEntryGroup]) {
        self.punchLineID = punchLineID
        self.selectedYear = selectedYear
        self.entryGroups = entryGroups
    }

    func fetchEntriesForEntryGroups() {
        DispatchQueue.main.async {
            Task {
                self.entriesDictionary = await APIManager.getJokeHistoryEntries(for: self.entryGroups)
            }
        }
    }

    func getRowData() -> [JokeHistoryRowDataItem] {

        var rowData: [JokeHistoryRowDataItem] = []

        for entryGroup in entryGroups where entryGroup.year == selectedYear {
            if !rowData.contains(where: { dataItem in
                dataItem.entryGroup.displayMonth == entryGroup.displayMonth
            }) {
                rowData.append(JokeHistoryRowDataItem(id: UUID().uuidString, entryGroup: entryGroup))
            }
        }

        return rowData

    }

    func getSelectedJokeHistoryEntries(selectedMonth: Int) -> [JokeHistoryEntry] {
        if let selectedEntryGroup = entryGroups.first(where: { entryGroup in
            entryGroup.year == selectedYear && entryGroup.month == selectedMonth
        }) {
            return entriesDictionary[selectedEntryGroup.id] ?? []
        } else {
            return []
        }
    }

}

class JokeHistoryEntriesViewModel: ObservableObject {

    @Published var jokeHistoryEntries: [JokeHistoryEntry] = []
    var entryGroup: JokeHistoryEntryGroup

    init(jokeHistoryEntries: [JokeHistoryEntry], entryGroup: JokeHistoryEntryGroup) {
        self.jokeHistoryEntries = jokeHistoryEntries
        self.entryGroup = entryGroup
    }

    init(jokeHistoryEntryGroup: JokeHistoryEntryGroup) {
        self.entryGroup = jokeHistoryEntryGroup
    }

    func fetchJokeHistoryEntriesForGroup() {
        Task {
            let entryDictionary = await APIManager.getJokeHistoryEntries(for: [entryGroup])
            self.jokeHistoryEntries = entryDictionary[entryGroup.id] ?? []
        }
    }

}

struct JokeHistoryRowDataItem: Identifiable {
    let id: String
    let entryGroup: JokeHistoryEntryGroup
}
