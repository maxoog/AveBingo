//
//  TokenStorage.swift
//
//
//  Created by Maksim Zenkov on 04.08.2024.
//

import Foundation

public final class TokenLoader {
    @Token
    private var token: String?

    public init() {}

    public var loadedToken: String {
        if let token {
            return token
        } else {
            let token = generateToken()
            self.token = token
            return token
        }
    }

    private func generateToken() -> String {
        UUID().uuidString
    }
}
