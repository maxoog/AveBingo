//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 13.07.2024.
//

import Foundation

public final class URLParser {
    public init() {}
    
    public func bingoId(from url: URL?) -> String? {
        guard let url, isBingoURL(url) else {
            return nil
        }
        return url.pathComponents.last
    }
    
    public func isBingoURL(_ url: URL) -> Bool {
        let components = url.pathComponents
        
        if components.count == 3, components.dropLast() == ["/", "bingo"] {
            return components.last?.isEmpty == false
        }
        
        return components.isEmpty
    }
}
