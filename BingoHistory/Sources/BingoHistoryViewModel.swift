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
import Combine

typealias Cards = [BingoModel]

enum HistoryState: Equatable {
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

    var models: [BingoModel] {
        switch self {
        case .loading, .error:
            []
        case .content(let cards):
            cards
        }
    }

    static func == (lhs: HistoryState, rhs: HistoryState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            true
        case (.content(let lhsCards), .content(let rhsCards)):
            lhsCards == rhsCards
        case (.error, .error):
            true
        default:
            false
        }
    }
}

@MainActor
public final class BingoHistoryViewModel: ObservableObject {
    private let bingoService: BingoService

    let bingoURLToOpen: URL?

    @Published var state: HistoryState = .loading
    @Published var bingoActionError: Bool = false
    private var loadingTask: Task<Void, Never>?
    private var cancellable: AnyCancellable?

    public init(bingoService: BingoService, bingoURLToOpen: URL?) {
        self.bingoService = bingoService
        self.bingoURLToOpen = bingoURLToOpen

        cancellable = bingoService.onChangePublisher.sink { [weak self] in
            Task {
                await self?.reload()
            }
        }
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
        var contentModels = state.models

        guard let deleteIndex = contentModels.firstIndex(where: {
            model.id == $0.id
        }) else {
            assertionFailure("Cannot find bingo")
            return
        }

        Task {
            do {
                contentModels.remove(at: deleteIndex)
                self.state = .content(contentModels)
                try await bingoService.deleteBingo(id: model.id)
            } catch {
                contentModels.insert(model, at: deleteIndex)
                self.state = .content(contentModels)
                bingoActionError = true
            }

            self.state = .content(contentModels)
        }
    }
}
