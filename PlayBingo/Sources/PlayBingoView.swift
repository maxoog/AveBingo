//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 12.07.2024.
//

import Foundation
import SwiftUI
import SharedUI
import Resources
import StoreKit
import CommonModels
import ServicesContracts

public struct PlayBingoView: View {
    let analyticsService: AnalyticsServiceProtocol
    @StateObject var viewModel: PlayBingoViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StaticState private var screenshotMaker: ScreenshotMaker?
    @State private var fullAppPromoPresented: Bool = false
    @State private var shareActivityPresented: Bool = false
    
    private let onEdit: ((BingoModel) -> Void)?
    
    public init(
        viewModel: PlayBingoViewModel,
        analyticsService: AnalyticsServiceProtocol,
        onEdit: ((BingoModel) -> Void)?
    ) {
        _viewModel = .init(wrappedValue: viewModel)
        self.analyticsService = analyticsService
        self.onEdit = onEdit
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewModel.loadBingo()
                    }
            case .error:
                ErrorView {
                    viewModel.loadBingo()
                }
            case .content(let bingoModel):
                bingoCardView(card: bingoModel)
                    .screenshotView { screenshotMaker in
                        self.screenshotMaker = screenshotMaker
                    }
            }
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if presentationMode.wrappedValue.isPresented {
                    HStack(spacing: 16) {
                        NavigationButton(iconName: "chevron_left_icon") {
                            analyticsService.logEvent(PlayEvent.backButton)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.bottom, 2)
                        
                        Text("My bingos")
                            .font(AveFont.headline3)
                            .foregroundStyle(AveColor.content)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 6) {
                    if viewModel.isMyBingo {
                        NavigationButton(
                            iconName: "pencil_icon",
                            onTap: editBingo
                        )
                    }
                    NavigationButton(
                        iconName: "share_icon",
                        onTap: {
                            shareActivityPresented = true
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $shareActivityPresented) {
            ShareBingoViewController(
                bingoURL: viewModel.bingoURL,
                getImage: { bingoImage() },
                analyticsService: analyticsService
            )
            .ignoresSafeArea(edges: .bottom)
        }
        .appStoreOverlay(isPresented: $fullAppPromoPresented) {
            SKOverlay.AppConfiguration(appIdentifier: "6621254236", position: .bottom)
        }
        .onFirstAppear {
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                if !presentationMode.wrappedValue.isPresented && !UserDefaults.standard.hasSeenFullAppPromo {
                    showFullAppPromo()
                }
            }
        }
    }
    
    private func bingoImage() -> UIImage? {
        return screenshotMaker?.screenshot()
    }
     
    private func editBingo() {
        guard let bingo = viewModel.state.bingo else {
            assertionFailure("Cannot find bingo")
            return
        }
        analyticsService.logEvent(PlayEvent.edit)
        onEdit?(bingo)
    }
    
    private func showFullAppPromo() {
        Task {
            try? await Task.sleep(nanoseconds: 6_000_000_000)
            fullAppPromoPresented = true
            UserDefaults.standard.hasSeenFullAppPromo = true
            try? await Task.sleep(nanoseconds: 30_000_000_000)
            fullAppPromoPresented = false
        }
    }
    
    private func bingoCardView(card bingoModel: BingoModel) -> some View {
        VStack(alignment: .center) {
            Image("app_logo", bundle: .assets)
                .resizable()
                .scaledToFit()
                .frame(height: 66)
            
            Text(bingoModel.name)
                .font(AveFont.content)
                .foregroundStyle(AveColor.content)
                .padding(.top, 32)
            
            BingoGridView(
                tiles: bingoModel.tiles,
                style: bingoModel.style,
                size: bingoModel.size,
                selectable: true,
                passTouchesToContent: false
            ) { (index, tile) in
                Text(tile.description)
                    .font(bingoModel.size.textFont)
                    .foregroundStyle(AveColor.content)
                    .padding(.vertical, 1)
                    .padding(.horizontal, bingoModel.size.horizontalPadding)
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
            }
            .padding(.top, 32)
        }
    }
}

extension UserDefaults {
    public enum Keys {
        static let hasSeenAppIntroduction = "has_seen_full_app_promo"
    }

    var hasSeenFullAppPromo: Bool {
        set {
            set(newValue, forKey: Keys.hasSeenAppIntroduction)
        }
        get {
            return bool(forKey: Keys.hasSeenAppIntroduction)
        }
    }
}
