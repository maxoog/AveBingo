//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 27.07.2024.
//

import Foundation

public protocol AnalyticsEvent {
    var name: String { get }
    var properties: [String: String] { get }
}

public enum HistoryEvent: String, AnalyticsEvent {
    case openPlayBingo
    case openEditBingo
    case openCreateBingo
    case deleteBingo
    
    public var name: String {
        "History View Event"
    }
    
    public var properties: [String: String] {
        ["name": self.rawValue]
    }
}

public enum EditEvent: AnalyticsEvent {
    case saveBingo(success: Bool)
    case backButton
    
    public var name: String {
        "Edit View Event"
    }
    
    public var properties: [String: String] {
        switch self {
        case .saveBingo(let success):
            ["name": "saveBingo", "success": success.description]
        case .backButton:
            ["name": "backButton"]
        }
    }
}

public enum PlayEvent: AnalyticsEvent {
    case edit
    case share(activity: String)
    case backButton
    
    public var name: String {
        "Play View Event"
    }
    
    public var properties: [String: String] {
        switch self {
        case .edit:
            ["name": "edit"]
        case .share(let activity):
            ["name": "share", "activity": activity]
        case .backButton:
            ["name": "backButton"]
        }
    }
}

public protocol AnalyticsServiceProtocol {
    func logEvent(_ event: AnalyticsEvent)
}
