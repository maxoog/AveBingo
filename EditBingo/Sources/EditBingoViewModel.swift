//
//  EditBingoViewModel.swift
//
//  Created by Maksim Zenkov on 11.07.2024.
//

import Foundation
import BingoServices
import ServicesContracts
import CommonModels

@MainActor
public final class EditBingoViewModel: ObservableObject {
    private let bingoService: BingoService
    private let analyticsService: AnalyticsServiceProtocol
    private let onSave: (BingoModel) -> Void

    @Published var model: EditableBingoModel {
        didSet {
            if !model.title.isEmpty {
                bingoValidationError = false
            }
            if model != oldValue {
                hasChanges = true
            }
        }
    }
    @Published var savingError: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var bingoValidationError: Bool = false

    @Published var hasChanges: Bool = false

    var isEditMode: Bool {
        bingoID != nil
    }

    @Published private var bingoID: String?

    public init(
        openType: EditBingoOpenType,
        bingoService: BingoService,
        analyticsService: AnalyticsServiceProtocol,
        onSave: @escaping (BingoModel) -> Void
    ) {
        self.bingoService = bingoService
        self.analyticsService = analyticsService
        self.onSave = onSave

        switch openType {
        case .createNew:
            self.model = .initDefault
        case .edit(let bingoModel):
            self.model = .init(from: bingoModel)
            self.bingoID = bingoModel.id
        }
    }

    func saveBingo() async {
        guard !model.title.isEmpty else {
            bingoValidationError = true
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            if let bingoID {
                let bingoModel = model.toBingoModel(id: bingoID)
                try await bingoService.editBingo(bingoModel)
                analyticsService.logEvent(EditEvent.saveBingo(success: true))
                onSave(bingoModel)
            } else {
                let bingoID = try await bingoService.createBingo(
                    name: model.title,
                    style: model.style,
                    emoji: model.emoji,
                    tiles: model.tiles.map { .init(description: $0) }
                )
                self.bingoID = bingoID
                analyticsService.logEvent(EditEvent.saveBingo(success: true))
                onSave(model.toBingoModel(id: bingoID))
            }
            hasChanges = false
        } catch {
            analyticsService.logEvent(EditEvent.saveBingo(success: false))
            self.savingError = true
        }
    }
}
