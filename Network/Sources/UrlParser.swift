//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 13.07.2024.
//

import Foundation

public final class URLParser {
    public init() {}
    
    public func parseBingoId(url: URL?) -> String? {
        guard let url else {
            return nil
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "id" })?.value
    }
}
