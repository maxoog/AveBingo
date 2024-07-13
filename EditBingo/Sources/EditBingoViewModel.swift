//
//  EditBingoViewModel.swift
//  AvitoTest
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation

struct BingoCard: Identifiable {
    let text: String
    
    let id: String = UUID().uuidString
}

public final class EditBingoViewModel: ObservableObject {
    @Published var bingoTitle: String = ""
    
    public init() {
        
    }

    private(set) var cards: [BingoCard] = [
        .init(text: ""),
        .init(text: ""),
        .init(text: ""),

        .init(text: ""),
        .init(text: ""),
        .init(text: ""),

        .init(text: ""),
        .init(text: ""),
        .init(text: "")
    ]
    
    func onCardEdit(index: Int, newText: String) {
        cards[index] = .init(text: newText)
    }
}

