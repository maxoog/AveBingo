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
                    EditablePlayBingoView(
                        screenFactory: screenFactory,
                        screenType: .editBingo(item)
                    ).anyView()
                }
            
            AveNavigationLink(
                item: $openPlayBingoItem) { item in
                    EditablePlayBingoView(
                        screenFactory: screenFactory,
                        screenType: .playBingo(item)
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
                            analyticsService.logEvent(HistoryEvent.openCreateBingo)
                        })
                    }
                } else {
                    cardsListView(cards: cards)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .overlay(alignment: .bottom) {
            GeometryReader { proxy in
                VStack(spacing: 24) {
                    Spacer()
                    
                    PopupErrorView(visible: $viewModel.bingoActionError)
                        .padding(.horizontal, 16)
                    
                    if viewModel.state.hasContent {
                        AveButton(iconName: "add_icon", text: "Add new") {
                            analyticsService.logEvent(HistoryEvent.openCreateBingo)
                            self.openEditBingoItem = .createNew
                        }
                        .padding(.bottom, proxy.safeAreaInsets.bottom == 0 ? 16 : 0)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .ignoresSafeArea(.keyboard)
        .animation(.default, value: viewModel.state)
        .onFirstAppear {
            Task {
                await viewModel.reload()
            }
            
            if let bingoURL = viewModel.bingoURLToOpen {
                openPlayBingoItem = .deeplink(bingoURL)
            }
        }
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
                                analyticsService.logEvent(HistoryEvent.openPlayBingo)
                                self.openPlayBingoItem = .card(card)
                                viewModel.objectWillChange.send()
                            },
                            onEdit: {
                                analyticsService.logEvent(HistoryEvent.openEditBingo)
                                self.openEditBingoItem = .edit(card)
                            },
                            onDelete: {
                                analyticsService.logEvent(HistoryEvent.deleteBingo)
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
