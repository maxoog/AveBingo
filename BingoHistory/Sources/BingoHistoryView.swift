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

public struct BingoHistoryView: View {
    let analyticsService: AnalyticsServiceProtocol
    let screenFactory: ScreenFactoryProtocol
    @ObservedObject var viewModel: BingoHistoryViewModel
    
    @State var editViewPresented: Bool = false
    @State var playViewPresented: Bool = false
    
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
                            editViewPresented = true
                            analyticsService.logEvent(.openBingoCreation)
                        })
                    }
                } else {
                    cardsListView(cards: cards)
                }
            }
        }
        .fullScreenCover(isPresented: $editViewPresented) {
            screenFactory.editBingoView()
        }
        .fullScreenCover(isPresented: $playViewPresented) {
            screenFactory.playBingoView()
        }
        .onFirstAppear {
            Task {
                await viewModel.reload()
            }
        }
    }
    
    @ViewBuilder
    private func cardsListView(cards: Cards) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(cards, id: \.id) { card in
                    BingoSnippetView(model: card)
                        .onTapGesture {
                            playViewPresented = true
                        }
                }
            }
            .padding(.top, 22)
        }
        .refreshable {
            await viewModel.reload()
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
