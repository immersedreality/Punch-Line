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
    case postSetupsFetch(requestObject: SetupFetchPostRequest, punchLineID: String, includeOffensiveContent: Bool)
    case setupReportOffensive(setupID: String)
    case setupReportUnfunny(setupID: String)
    case postJoke(requestObject: JokePostRequest)
    case postJokesFetch(requestObject: JokeFetchPostRequest, punchLineID: String, includeOffensiveContent: Bool)
    case jokeVoteHa(jokeID: String)
    case jokeVoteMeh(jokeID: String)
    case jokeVoteUgh(jokeID: String)
    case jokeReportOffensive(jokeID: String)
    case jokeReportTooFunny(jokeID: String)
    case getJokeHistoryEntries(entryGroupIDs: [String])
    case getSurvivingJokes(entryID: String, includeOffensiveContent: Bool)
    case jokeLookupSearchQuery(searchQuery: String, includeOffensiveContent: Bool)

    var path: String {

        var domain = ""

        switch APIManager.networkEnvironment {
        case .mock:
            break
        case .dev:
            domain = RequestComponents.devAPIDomain
        case .test:
            domain = RequestComponents.testAPIDomain
        case .prod:
            domain = RequestComponents.prodAPIDomain
        }

        switch self {
        case .getPublicPunchLines:
            return domain + RequestComponents.publicpunchlines
        case .getPrivatePunchLinesWithIDs(let punchLineIDs):
            return domain + RequestComponents.privatepunchlines + RequestComponents.punchLineIDs + punchLineIDs.joined(separator: ",")
        case .getPrivatePunchLineWithJoinCode(let joinCode):
            return domain + RequestComponents.privatepunchlines + "/\(joinCode)"
        case .postPrivatePunchLine:
            return domain + RequestComponents.privatepunchlines
        case .deletePrivatePunchLine(let punchLineID):
            return domain + RequestComponents.privatepunchlines + RequestComponents.punchLineID + punchLineID
        case .postSetup:
            return domain + RequestComponents.setups
        case .postSetupsFetch(_, let punchLineID, let includeOffensiveContent):
            return domain + RequestComponents.setups + RequestComponents.fetch + RequestComponents.punchLineID + punchLineID + RequestComponents.includeOffensiveContent + includeOffensiveContent.description
        case .setupReportOffensive(let setupID):
            return domain + RequestComponents.setups + RequestComponents.offensive + RequestComponents.setupID + setupID
        case .setupReportUnfunny(let setupID):
            return domain + RequestComponents.setups + RequestComponents.unfunny + RequestComponents.setupID + setupID
        case .postJoke:
            return domain + RequestComponents.jokes
        case .postJokesFetch(_, let punchLineID, let includeOffensiveContent):
            return domain + RequestComponents.jokes + RequestComponents.fetch + RequestComponents.punchLineID + punchLineID + RequestComponents.includeOffensiveContent + includeOffensiveContent.description
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
        case .getJokeHistoryEntries(let entryGroupIDs):
            return domain + RequestComponents.jokehistoryentries + RequestComponents.entryGroupIDs + entryGroupIDs.joined(separator: ",")
        case .getSurvivingJokes(let entryID, let includeOffensiveContent):
            return domain + RequestComponents.survivingjokes + RequestComponents.entryID + entryID + RequestComponents.includeOffensiveContent + includeOffensiveContent.description
        case .jokeLookupSearchQuery(let searchQuery, let includeOffensiveContent):
            return domain + RequestComponents.survivingjokes + RequestComponents.searchQuery + searchQuery + RequestComponents.includeOffensiveContent + includeOffensiveContent.description
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
        case .postSetupsFetch:
            return HTTPMethods.post
        case .setupReportOffensive:
            return HTTPMethods.patch
        case .setupReportUnfunny:
            return HTTPMethods.patch
        case .postJoke:
            return HTTPMethods.post
        case .postJokesFetch:
            return HTTPMethods.post
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
        case .getJokeHistoryEntries:
            return HTTPMethods.get
        case .getSurvivingJokes:
            return HTTPMethods.get
        case .jokeLookupSearchQuery:
            return HTTPMethods.get
        }
        
    }

}
