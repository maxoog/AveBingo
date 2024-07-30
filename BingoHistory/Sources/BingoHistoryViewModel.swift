//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import BingoServices
import ServicesContracts

typealias Cards = [BingoModel]

enum HistoryState {
    case loading
    case error(Error)
    case content(Cards)
}

enum SomeError: Error {
    case main
}

@MainActor
public final class BingoHistoryViewModel: ObservableObject {
    private let bingoService: BingoService
    
    @Published var state: HistoryState = .loading
    private var loadingTask: Task<Void, Never>? = nil

    public init(bingoService: BingoService) {
        self.bingoService = bingoService
    }
    
    func reload() {
        guard loadingTask == nil else {
            return
        }
        
        self.state = .loading
        
        loadingTask = Task.detached { @MainActor [weak self] in
            guard let self else {
                return
            }
            
            defer {
                loadingTask = nil
            }
            
            do {
                let cards = try await bingoService.getBingoHistory()
                self.state = .content(cards)
            } catch {
                self.state = .error(error)
            }
        }
    }
}
