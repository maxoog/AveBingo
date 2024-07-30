//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import ServicesContracts
import NetworkCore

public final class BingoServiceForAppClip: BingoProviderProtocol {
    private let urlParser = URLParser()
    private let client = URLSession.shared
    
    public init() {}
    
    public func getBingo(url: URL?) async throws -> BingoModel {
        guard let id = url.flatMap({ urlParser.bingoId(from: $0) }),
              let url = URL(string: "\(NetworkConstants.apiBaseAddress)/api/v1/bingo/\(id)")
        else {
            assertionFailure("Wrong bingo url")
            throw BingoError.wrongUrl
        }
        
        return try await withUnsafeThrowingContinuation { [weak self] continuation in
            guard let self else {
                return
            }
            
            let urlRequest = URLRequest(url: url)

            client.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    if let bingoResponse = try? JSONDecoder().decode(
                        BingoResponse.self,
                        from: data
                    ) {
                        continuation.resume(returning: bingoResponse.toBingoCardModel())
                    } else {
                        continuation.resume(throwing: BingoError.notFound)
                    }
                } else {
                    continuation.resume(throwing: BingoError.unknownError)
                }
            }.resume()
        }
    }
}

