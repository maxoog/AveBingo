//
//  File.swift
//  
//
//  Created by Maksim on 26.10.2024.
//

import Foundation
import XCTest
import CommonModels
import NetworkCore

final class NetworkCoreTests: XCTestCase {
    func testBingoMapping() {
        let bingoResponse = BingoResponse(
            id: "some_id",
            title: "some_title",
            style: "retro",
            emoji: ":)",
            tiles: createTilesArray().map { Tile(description: $0) }
        )

        let bingoCardReferenceModel = BingoModel(
            id: "some_id",
            name: "some_title",
            style: .retro,
            size: .small,
            emoji: ":)",
            tiles: createTilesArray().map { BingoModel.Tile(description: $0) }
        )

        XCTAssertEqual(bingoResponse.toBingoCardModel(), bingoCardReferenceModel)
    }

    private func createTilesArray() -> [String] {
        [
            "some_tile_description1",
            "some_tile_description2",
            "some_tile_description3",
            "some_tile_description4",
            "some_tile_description5",
            "some_tile_description6",
            "some_tile_description7",
            "some_tile_description8",
            "some_tile_description9"
        ]
    }
}
