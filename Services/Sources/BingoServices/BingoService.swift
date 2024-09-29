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
import Combine

public typealias BingoID = String

@MainActor
public final class BingoService: BingoProviderProtocol {
    private let client: NetworkClient
    private let urlParser = URLParser()
    private let onChangeSubject = PassthroughSubject<Void, Never>()

    public var onChangePublisher: AnyPublisher<Void, Never> {
        onChangeSubject.eraseToAnyPublisher()
    }

    public init(client: NetworkClient) {
        self.client = client
    }

    public func createBingo(
        name: String,
        style: BingoCellStyle,
        emoji: String,
        tiles: [Tile]
    ) async throws -> BingoID {
        defer {
            onChangeSubject.send()
        }

        let addBingoRequestModel = AddBingoRequest(
            title: name,
            style: style.rawValue,
            emoji: emoji,
            tiles: tiles
        )

        let addBingoRequest = client.session.request(
            "\(client.host)/api/v1/bingo",
            method: .post,
            parameters: addBingoRequestModel,
            encoder: JSONParameterEncoder.default
        )

        let response: AddBingoResponse = try await addBingoRequest.decodable()
        return response.id
    }

    public func editBingo(_ bingo: BingoModel) async throws {
        defer {
            onChangeSubject.send()
        }

        let editBingoRequestModel = bingo.toAddBingoRequest()

        try await client.session.request(
            "\(client.host)/api/v1/bingo/\(bingo.id)",
            method: .put,
            parameters: editBingoRequestModel,
            encoder: JSONParameterEncoder.default
        ).emptyBodyResponse()
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
        let bingoHistoryRequest = client.session.request(
            "\(client.host)/api/v1/bingo"
        )

        let historyResponse = try await bingoHistoryRequest.decodable() as [BingoResponse]

        return historyResponse.map { $0.toBingoCardModel() }
    }

    public func deleteBingo(id: String) async throws {
        try await client.session.request(
            "\(client.host)/api/v1/bingo/\(id)",
            method: .delete
        ).emptyBodyResponse()
    }
}

private extension DataRequest {
    func emptyBodyResponse() async throws {
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            self.response { response in
                if let error = response.error {
                    continuation.resume(throwing: error)
                } else if response.response?.statusCode != 200 {
                    continuation.resume(throwing: BingoError.unknownError)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
