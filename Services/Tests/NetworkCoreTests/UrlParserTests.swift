//
//  File.swift
//  
//
//  Created by Maksim on 26.10.2024.
//

import Foundation
import NetworkCore
import XCTest

final class URLParserTests: XCTestCase {
    func testUrlParserIsBingoID() {
        let url = URL(string: "https://avebingo.com/bingo/some_id")

        XCTAssertEqual(URLParser().bingoId(from: url), "some_id")
    }
}
