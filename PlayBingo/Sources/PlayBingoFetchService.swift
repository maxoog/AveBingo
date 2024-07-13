//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 13.07.2024.
//

import Foundation
import Network
import Alamofire

enum PlayBingoError: Error {
    case wrongUrl
}

public final class PlayBingoFetchService {
    private let client: NetworkClient
    private let urlParser = URLParser()
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    func getBingo(url: URL?) async throws -> BingoCardModel {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return BingoCardModel.defaultModel
        
        guard let id = url.map({ urlParser.parseBingoId(url: $0) }) else {
            assertionFailure("Wrong bingo url")
            throw PlayBingoError.wrongUrl
        }
        
        let bingoCardRequest = client.session.request(
            "\(client.host)/bingo",
            parameters: ["id": id]
        )
        
        return try await bingoCardRequest.decodable() as BingoCardModel
    }
}
