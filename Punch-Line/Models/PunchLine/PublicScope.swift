//
//  PublicScope.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 9/14/22.
//  Copyright © 2022 Bozo Design Labs. All rights reserved.
//

import Foundation

enum PublicScope {
    case country, stateOrProvince, city

    var displayName: String {
        switch self {
        case .country:
            return RegionDisplayNames.country
        case .stateOrProvince:
            return RegionDisplayNames.stateOrProvince
        case .city:
            return RegionDisplayNames.city
        }
    }

}
