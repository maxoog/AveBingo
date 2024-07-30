//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 27.07.2024.
//

import Foundation

public enum AnalyticsEvent {
    case openBingoCreation
}

public protocol AnalyticsServiceProtocol {
    func logEvent(_ event: AnalyticsEvent)
}
