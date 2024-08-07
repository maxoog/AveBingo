//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import BingoServices
import ServicesContracts
import CommonModels

typealias Cards = [BingoModel]

enum HistoryState {
    case loading
    case error(Error)
    case content(Cards)
    
    var hasContent: Bool {
        switch self {
        case .loading, .error:
            false
        case .content(let cards):
            !cards.isEmpty
        }
    }
}

enum SomeError: Error {
    case main
}

@MainActor
public final class BingoHistoryViewModel: ObservableObject {
    private let bingoService: BingoService
    
    @Published var state: HistoryState = .loading
    @Published var bingoActionError: Error? = nil
    private var loadingTask: Task<Void, Never>? = nil

    public init(bingoService: BingoService) {
        self.bingoService = bingoService
    }
    
    func reload() async {
        guard loadingTask == nil else {
            await loadingTask?.value
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
        
        await loadingTask?.value
    }
    
    func deleteBingo(model: BingoModel) {
        Task {
            do {
                try await bingoService.deleteBingo(id: model.id)
            } catch {
                bingoActionError = error
            }
        }
    }
    
    func removeBingo() {
        
    }
}
