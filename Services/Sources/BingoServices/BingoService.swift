//
//  File.swift
//
//
//  Created by Maksim Zenkov on 13.07.2024.
//

import Foundation
import NetworkClient
import Alamofire
import ServicesContracts
import NetworkCore
import CommonModels

public typealias BingoID = String

public final class BingoService: BingoProviderProtocol {
    private let client: NetworkClient
    private let urlParser = URLParser()
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func postBingo(bingo: BingoModel) async throws -> BingoID {
        let addBingoRequest = bingo.toAddBingoRequest()
        
        let postBingoRequest = client.session.request(
            "\(client.host)/api/v1/bingo",
            method: .post,
            parameters: addBingoRequest,
            encoder: JSONParameterEncoder.default
        )
        
        let response: AddBingoResponse = try await postBingoRequest.decodable()
        return response.id
    }
    
    public func getBingo(url: URL?) async throws -> BingoModel {
        guard let id = url.flatMap({ urlParser.bingoId(from: $0) }) else {
            assertionFailure("Wrong bingo url")
            throw BingoError.wrongUrl
        }
        
        let bingoCardRequest = client.session.request(
            "\(client.host)/api/v1/bingo/\(id)"
        )
        
        let bingoResponse = try await bingoCardRequest.decodable() as BingoResponse
        
        return bingoResponse.toBingoCardModel()
    }
    
    public func getBingoHistory() async throws -> [BingoModel] {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return []
        return [.defaultModel, .defaultModel, .defaultModel]
    }
}

