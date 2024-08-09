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
    @ObservedObject var viewModel: BingoHistoryViewModel
    let screenFactory: ScreenFactoryProtocol
    
    @State var openEditBingoItem: EditBingoOpenType? = nil
    @State var openPlayBingoItem: PlayBingoOpenType? = nil
    
    public init(
        viewModel: BingoHistoryViewModel,
        analyticsService: AnalyticsServiceProtocol,
        screenFactory: ScreenFactoryProtocol
    ) {
        self.viewModel = viewModel
        self.analyticsService = analyticsService
        self.screenFactory = screenFactory
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
            AveNavigationLink(
                item: $openEditBingoItem) { item in
                    screenFactory.editBingoView(openType: item)
                }
            
            AveNavigationLink(
                item: $openPlayBingoItem) { item in
                    EditablePlayBingoView(
                        screenFactory: screenFactory,
                        openType: item
                    ).anyView()
                }
            
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
                            self.openEditBingoItem = .createNew
                            analyticsService.logEvent(.openBingoCreation)
                        })
                    }
                } else {
                    cardsListView(cards: cards)
                }
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.state.hasContent {
                AveButton(iconName: "add_icon", text: "Add new") {
                    self.openEditBingoItem = .createNew
                }
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.reload()
            }
        }
        .ignoresSafeArea(.keyboard)
        .animation(.default, value: viewModel.state)
    }
    
    @ViewBuilder
    private func cardsListView(cards: Cards) -> some View {
        SwipeViewGroup {
            ScrollView {
                LazyVStack {
                    ForEach(cards, id: \.id) { card in
                        BingoSnippetView(
                            model: card,
                            onTap: {
                                self.openPlayBingoItem = .card(card)
                                viewModel.objectWillChange.send()
                            },
                            onEdit: {
                                self.openEditBingoItem = .edit(card)
                            },
                            onDelete: {
                                viewModel.deleteBingo(model: card)
                            }
                        )
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
