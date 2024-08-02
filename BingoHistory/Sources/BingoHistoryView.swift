//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 24.07.2024.
//

import Foundation
import SwiftUI
import ScreenFactoryContracts
import Resources
import SharedUI
import ServicesContracts
import CommonModels

public struct BingoHistoryView: View {
    let analyticsService: AnalyticsServiceProtocol
    let screenFactory: ScreenFactoryProtocol
    @ObservedObject var viewModel: BingoHistoryViewModel
    
    @State var editViewOpenItem: EditBingoOpenType? = nil
    
    public init(
        screenFactory: ScreenFactoryProtocol,
        viewModel: BingoHistoryViewModel,
        analyticsService: AnalyticsServiceProtocol
    ) {
        self.screenFactory = screenFactory
        self.viewModel = viewModel
        self.analyticsService = analyticsService
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("MY BINGOS")
                .font(AveFont.headline1)
                .foregroundStyle(AveColor.content)
                .padding(.top, 8)
            
            
            switch viewModel.state {
            case .loading:
               centeredView { ProgressView() }
            case .error(_):
                centeredView {
                    ErrorView(onReloadTap: {
                        Task {
                            await viewModel.reload()
                        }
                    })
                }
            case .content(let cards):
                if cards.isEmpty {
                    centeredView {
                        EmptyHistoryView(onAddBingoTap: {
                            editViewOpenItem = .createNew
                            analyticsService.logEvent(.openBingoCreation)
                        })
                    }
                } else {
                    cardsListView(cards: cards)
                }
            }
        }
        .fullScreenCover(item: $editViewOpenItem) { openType in
            screenFactory.editBingoView(openType: openType)
        }
        .onFirstAppear {
            Task {
                await viewModel.reload()
            }
        }
    }
    
    @ViewBuilder
    private func cardsListView(cards: Cards) -> some View {
        SwipeViewGroup {
            ScrollView {
                LazyVStack {
                    ForEach(cards, id: \.id) { card in
                        NavigationLink {
                            screenFactory.playBingoView(openType: .card(card))
                        } label: {
                            BingoSnippetView(
                                model: card,
                                onEdit: {
                                    self.editViewOpenItem = .edit(card)
                                },
                                onDelete: {
                                    
                                }
                            )
                        }
                    }
                }
                .padding(.top, 22)
            }
            .refreshable {
                await viewModel.reload()
            }
        }
    }
    
    private func centeredView<Content: View>(content: () -> Content) -> some View {
        VStack(spacing: 0) {
            Spacer()
            content()
            Spacer()
        }
    }
}
