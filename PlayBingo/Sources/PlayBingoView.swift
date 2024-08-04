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
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PlayBingoViewModel
    
    @State private var screenshotMaker: ScreenshotMaker?
    @State private var fullAppPromoPresented: Bool = false
    @State private var shareActivityPresented: Bool = false
    
    public init(viewModel: PlayBingoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .onAppear(perform: viewModel.loadBingo)
            case .error(let error):
                ErrorView(error)
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
            #if !APP_CLIP
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 16) {
                    NavigationButton(iconName: "chevron_left_icon") {
                        dismiss()
                    }
                    
                    Text("My bingos")
                        .font(AveFont.headline3)
                        .foregroundStyle(AveColor.content)
                }
            }
            #endif
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 6) {
                    #if !APP_CLIP
                    NavigationButton(
                        iconName: "pencil_icon",
                        onTap: editBingo
                    )
                    #endif
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
        #if !APP_CLIP
        .appStoreOverlay(isPresented: $fullAppPromoPresented) {
            SKOverlay.AppConfiguration(appIdentifier: "6535681093", position: .bottom)
        }
        #endif
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
                    .font(AveFont.content2)
                    .foregroundStyle(AveColor.content)
                    .padding(8)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 32)
        }
    }
}

private struct ErrorView: View {
    let error: Error
    
    init(_ error: Error) {
        self.error = error
    }
    
    var body: some View {
        Text("Some error occured \(error)")
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
