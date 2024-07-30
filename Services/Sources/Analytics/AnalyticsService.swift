//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 27.07.2024.
//

import Foundation
import Mixpanel
import ServicesContracts

fileprivate extension AnalyticsEvent {
    var analyticsName: String {
        switch self {
        case .openBingoCreation:
            "Open bingo creation"
        }
    }
    
    var properties: Properties { // [String: MixpanelType]
        switch self {
        case .openBingoCreation:
            [:]
        }
    }
}

public final class AnalyticsService: AnalyticsServiceProtocol {
    public init() {}
    
    public func logEvent(_ event: ServicesContracts.AnalyticsEvent) {
        Mixpanel.mainInstance().track(
            event: event.analyticsName,
            properties: event.properties
        )
    }
}
