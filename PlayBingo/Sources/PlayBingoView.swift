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

public struct PlayBingoView: View {
    @ObservedObject var viewModel: PlayBingoViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var screenshotMaker: ScreenshotMaker?
    @State private var fullAppPromoPresented: Bool = false
    @State private var shareActivityPresented: Bool = false
    
    private let onEdit: ((BingoModel) -> Void)?
    
    public init(viewModel: PlayBingoViewModel, onEdit: ((BingoModel) -> Void)?) {
        self.viewModel = viewModel
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
            ShareBingoViewController(bingoURL: viewModel.bingoURL, image: bingoImage())
                .ignoresSafeArea(edges: .bottom)
        }
        .appStoreOverlay(isPresented: $fullAppPromoPresented) {
            SKOverlay.AppConfiguration(appIdentifier: "6621254236", position: .bottom)
        }
        .onContinueUserActivity("NSUserActivityTypeBrowsingWeb", perform: { userActivity in
            viewModel.bingoURL = userActivity.webpageURL
            viewModel.loadBingo()
        })
    }
    
    private func bingoImage() -> UIImage? {
        return screenshotMaker?.screenshot()
    }
    
    private func makeScreenshot() {
        if case .content = viewModel.state,
           let image = bingoImage()
        {
            self.copyImageToClipboard(image: image)
        }
    }
     
    private func editBingo() {
        guard let bingo = viewModel.state.bingo else {
            assertionFailure("Cannot find bingo")
            return
        }
        onEdit?(bingo)
    }
    
    private func showFullAppPromo() {
        fullAppPromoPresented = true
        Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
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

extension View {
    func copyImageToClipboard(image: UIImage) {
        let pasteboard = UIPasteboard.general
        pasteboard.image = image
        
        // To check if the image was successfully set in the clipboard.
        if pasteboard.image != nil {
            // If the image is not nil, it means it was successfully copied to the clipboard.
            print("Image copied to clipboard!")
        } else {
            // If the image is nil, print a failure message.
            print("Failed to copy image to clipboard.")
        }
    }
}
