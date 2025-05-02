//
//  APIRequestType.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 5/1/25.
//

enum APIRequestType {
    case getPublicPunchLines
    case getPrivatePunchLinesWithIDs(punchLineIDs: [String])
    case getPrivatePunchLineWithJoinCode(joinCode: String)
    case postPrivatePunchLine(requestObject: PrivatePunchLinePostRequest)
    case deletePrivatePunchLine(punchLineID: String)
    case postSetup(requestObject: SetupPostRequest)
    case getSetups(punchLineID: String, includeOffensiveContent: Bool)
    case setupReportOffensive(setupID: String)
    case setupReportUnfunny(setupID: String)
    case postJoke(requestObject: JokePostRequest)
    case getJokes(punchLineID: String, includeOffensiveContent: Bool)
    case jokeVoteHa(jokeID: String)
    case jokeVoteMeh(jokeID: String)
    case jokeVoteUgh(jokeID: String)
    case jokeReportOffensive(jokeID: String)
    case jokeReportTooFunny(jokeID: String)
    case getJokeHistoryEntryGroups(punchLineIDs: [String])
    case getJokeHistoryEntries(entryGroupID: String)
    case jokeLookupSearchQuery(searchQuery: String)

    var path: String {

        var domain = ""

        switch APIManager.networkEnvironment {
        case .mock:
            break
        case .local:
            domain = RequestComponents.localAPIDomain
        case .dev:
            domain = RequestComponents.devAPIDomain
        case .prod:
            domain = RequestComponents.prodAPIDomain
        }

        switch self {
        case .getPublicPunchLines:
            return domain + RequestComponents.publicpunchlines
        case .getPrivatePunchLinesWithIDs(let punchLineIDs):
            return domain + RequestComponents.privatepunchlines + RequestComponents.punchLineIDs + punchLineIDs.joined(separator: ", ")
        case .getPrivatePunchLineWithJoinCode(let joinCode):
            return domain + RequestComponents.privatepunchlines + "/\(joinCode)"
        case .postPrivatePunchLine:
            return domain + RequestComponents.privatepunchlines
        case .deletePrivatePunchLine(let punchLineID):
            return domain + RequestComponents.privatepunchlines + RequestComponents.punchLineID + punchLineID
        case .postSetup:
            return domain + RequestComponents.setups
        case .getSetups(let punchLineID, let includeOffensiveContent):
            return domain + RequestComponents.setups + RequestComponents.punchLineID + punchLineID + RequestComponents.includeOffensiveContent + includeOffensiveContent.description
        case .setupReportOffensive(let setupID):
            return domain + RequestComponents.setups + RequestComponents.offensive + RequestComponents.setupID + setupID
        case .setupReportUnfunny(let setupID):
            return domain + RequestComponents.setups + RequestComponents.unfunny + RequestComponents.setupID + setupID
        case .postJoke:
            return domain + RequestComponents.jokes
        case .getJokes(let punchLineID, let includeOffensiveContent):
            return domain + RequestComponents.jokes + RequestComponents.punchLineID + punchLineID + RequestComponents.includeOffensiveContent + includeOffensiveContent.description
        case .jokeVoteHa(let jokeID):
            return domain + RequestComponents.jokes + RequestComponents.ha + RequestComponents.jokeID + jokeID
        case .jokeVoteMeh(let jokeID):
            return domain + RequestComponents.jokes + RequestComponents.meh + RequestComponents.jokeID + jokeID
        case .jokeVoteUgh(let jokeID):
            return domain + RequestComponents.jokes + RequestComponents.ugh + RequestComponents.jokeID + jokeID
        case .jokeReportOffensive(let jokeID):
            return domain + RequestComponents.jokes + RequestComponents.offensive + RequestComponents.jokeID + jokeID
        case .jokeReportTooFunny(let jokeID):
            return domain + RequestComponents.jokes + RequestComponents.toofunny + RequestComponents.jokeID + jokeID
        case .getJokeHistoryEntryGroups(let punchLineIDs):
            return domain + RequestComponents.jokehistoryentrygroups + RequestComponents.punchLineIDs + punchLineIDs.joined(separator: ", ")
        case .getJokeHistoryEntries(let entryGroupID):
            return domain + RequestComponents.jokehistoryentries + RequestComponents.entryGroupID + entryGroupID
        case .jokeLookupSearchQuery(let searchQuery):
            return domain + RequestComponents.jokelookup + RequestComponents.searchQuery + searchQuery
        }
        
    }

    var httpMethod: String {

        switch self {
        case .getPublicPunchLines:
            return HTTPMethods.get
        case .getPrivatePunchLinesWithIDs:
            return HTTPMethods.get
        case .getPrivatePunchLineWithJoinCode:
            return HTTPMethods.get
        case .postPrivatePunchLine:
            return HTTPMethods.post
        case .deletePrivatePunchLine:
            return HTTPMethods.delete
        case .postSetup:
            return HTTPMethods.post
        case .getSetups:
            return HTTPMethods.get
        case .setupReportOffensive:
            return HTTPMethods.patch
        case .setupReportUnfunny:
            return HTTPMethods.patch
        case .postJoke:
            return HTTPMethods.post
        case .getJokes:
            return HTTPMethods.get
        case .jokeVoteHa:
            return HTTPMethods.patch
        case .jokeVoteMeh:
            return HTTPMethods.patch
        case .jokeVoteUgh:
            return HTTPMethods.patch
        case .jokeReportOffensive:
            return HTTPMethods.patch
        case .jokeReportTooFunny:
            return HTTPMethods.patch
        case .getJokeHistoryEntryGroups:
            return HTTPMethods.get
        case .getJokeHistoryEntries:
            return HTTPMethods.get
        case .jokeLookupSearchQuery:
            return HTTPMethods.get
        }
        
    }

}
