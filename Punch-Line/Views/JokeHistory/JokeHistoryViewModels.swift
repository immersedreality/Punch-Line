//
//  JokeHistoryViewModels.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/26/25.
//

import Foundation

class JokeHistoryYearsViewModel {

    let punchLineID: String

    init(punchLineID: String) {
        self.punchLineID = punchLineID
    }

    func getRowData() -> [JokeHistoryRowDataItem] {

        guard let entryGroups = TestDataManager.testJokeHistoryEntryGroups[punchLineID] else { return [] }

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

    init(punchLineID: String, selectedYear: Int) {
        self.punchLineID = punchLineID
        self.selectedYear = selectedYear
    }

    func getRowData() -> [JokeHistoryRowDataItem] {

        guard let entryGroups = TestDataManager.testJokeHistoryEntryGroups[punchLineID] else { return [] }

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

    func getSelectedJokeHistoryEntries(for punchLineID: String, selectedMonth: Int) -> [JokeHistoryEntry] {
        guard let entryGroups = TestDataManager.testJokeHistoryEntryGroups[punchLineID] else { return [] }
        guard let selectedJokeHistoryEntryGroup = entryGroups.first(where: { entryGroup in
            entryGroup.year == selectedYear && entryGroup.month == selectedMonth
        }) else { return [] }
        return selectedJokeHistoryEntryGroup.entries ?? []
    }

}

class JokeHistoryEntriesViewModel {

    let jokeHistoryEntries: [JokeHistoryEntry]

    init(jokeHistoryEntries: [JokeHistoryEntry]) {
        self.jokeHistoryEntries = jokeHistoryEntries
    }

}

struct JokeHistoryRowDataItem: Identifiable {
    let id: String
    let rowTitle: String
    let rowValue: Int
}
