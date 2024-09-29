//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 27.07.2024.
//

import Foundation
import Mixpanel
import ServicesContracts

public final class AnalyticsService: AnalyticsServiceProtocol {
    public init() {}

    public func logEvent(_ event: AnalyticsEvent) {
        print("logging event \(event.name) with properties \(event.properties)")

        Mixpanel.mainInstance().track(
            event: event.name,
            properties: event.properties
        )
    }
}
