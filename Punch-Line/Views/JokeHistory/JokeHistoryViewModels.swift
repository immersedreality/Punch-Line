//
//  JokeHistoryViewModels.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 3/26/25.
//

import Foundation

class JokeHistoryYearsViewModel {

    func getRowData() -> [JokeHistoryRowDataItem] {

        var rowData: [JokeHistoryRowDataItem] = []

        for entryGroup in TestDataManager.testJokeHistoryEntryGroups {
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

    let selectedYear: Int

    init(selectedYear: Int) {
        self.selectedYear = selectedYear
    }

    func getRowData() -> [JokeHistoryRowDataItem] {

        var rowData: [JokeHistoryRowDataItem] = []

        for entryGroup in TestDataManager.testJokeHistoryEntryGroups where entryGroup.year == selectedYear {
            if !rowData.contains(where: { dataItem in
                dataItem.rowTitle == entryGroup.displayMonth
            }) {
                rowData.append(JokeHistoryRowDataItem(id: UUID().uuidString, rowTitle: entryGroup.displayMonth, rowValue: entryGroup.month))
            }
        }

        return rowData

    }

    func getSelectedJokeHistoryEntries(for selectedMonth: Int) -> [JokeHistoryEntry] {
        guard let selectedJokeHistoryEntryGroup = TestDataManager.testJokeHistoryEntryGroups.first(where: { entryGroup in
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
