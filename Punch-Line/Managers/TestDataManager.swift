//
//  TestDataManager.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 1/17/23.
//  Copyright © 2023 Bozo Design Labs. All rights reserved.
//

import Foundation
import CloudKit

final class TestDataManager {

    private static let container = CKContainer.default()

    static let testSetUps = [
        "Why did the chicken suck the chode?",
        "Yo, what the heck is that all about my man?",
        "What do you call a newspaper bent backward?",
        "Hows about this and that and the other thing...",
        "Poop man go what?  He what what what?",
        "What are we going to do without men?",
        "If you go over to the bank, what is going to be over there?",
        "A man, a woman, and thirty-five guys walk into a bar...",
        "What happened to the bank man who farted and then said 'Uh Oh'?",
        "Farting isn't cool and a million other farts agree.  Do you?"
    ]

    static let testSetUpAuthors = [
        "Tim Allen",
        "Ingmar Bergman",
        "Jeremy Piven",
        "Federico Fellini",
        "Sigourney Weaver",
        "Timothy Allenstein",
        "Ethan Klein",
        "Robert Bresson",
        "George Clooney",
        "Josh Incredible"
    ]

    static let testPunchlines = [
        "That's just how it be, my man.",
        "Something about the smell and also the other smell.",
        "Whooop, there it is!",
        "Film school is for films and for school.",
        "Cryptocurrency is fun and so is fun.",
        "The internet is for fun and is also for more fun.",
        "I can see through windows because I have talent.",
        "Maybe just because, you know.  Maybe just because.",
        "People are people, too.  People, especially.",
        "No one likes pooping except for the really big poopers."
    ]

    static let testPunchlineAuthors = [
        "Tim Allen",
        "Ingmar Bergman",
        "Jeremy Piven",
        "Federico Fellini",
        "Sigourney Weaver",
        "Timothy Allenstein",
        "Ethan Klein",
        "Robert Bresson",
        "George Clooney",
        "Josh Incredible"
    ]

    class func createTestCompletedPunchLines(for launcher: PunchLineLauncher, numberOfDays: Int) async {
        let publicDatabase = container.publicCloudDatabase

        do {
            for dayNumber in 1...numberOfDays {
                guard let date = Calendar.current.date(byAdding: .day, value: -dayNumber, to: Date()) else { continue }
                let completedPunchLineRecord = CKRecord(recordType: CompletedPunchLineRecordKeys.type)
                completedPunchLineRecord[CompletedPunchLineRecordKeys.displayName] = launcher.displayName as CKRecordValue
                completedPunchLineRecord[CompletedPunchLineRecordKeys.scope] = launcher.scope.rawValue as CKRecordValue
                completedPunchLineRecord[CompletedPunchLineRecordKeys.launcherID] = launcher.cloudKitID.recordName as CKRecordValue
                completedPunchLineRecord[CompletedPunchLineRecordKeys.dateCompleted] = date as CKRecordValue
                completedPunchLineRecord[CompletedPunchLineRecordKeys.topTenSetUps] = testSetUps as CKRecordValue
                completedPunchLineRecord[CompletedPunchLineRecordKeys.topTenSetUpAuthors] = testSetUpAuthors as CKRecordValue
                completedPunchLineRecord[CompletedPunchLineRecordKeys.topTenPunchlines] = testPunchlines as CKRecordValue
                completedPunchLineRecord[CompletedPunchLineRecordKeys.topTenPunchlineAuthors] = testPunchlineAuthors as CKRecordValue
                try await publicDatabase.save(completedPunchLineRecord)
            }
        } catch {
            return
        }

    }

}
