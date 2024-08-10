//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 30.07.2024.
//

import Foundation
import SwiftUI
import ServicesContracts
import Resources
import SharedUI
import CommonModels

struct BingoSnippetView: View {
    let model: BingoModel
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        SwipeView {
            Button(action: onTap) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AveColor.backgroundLight)
                        .frame(height: 72)
                    
                    HStack(spacing: 16) {
                        bingoEmojiImage
                            .resizable()
                            .frame(width: 20, height: 20)
                            .background {
                                AveColor.background
                                    .clipShape(Circle())
                                    .frame(width: 32, height: 32)
                            }
                        
                        Text(model.name)
                            .font(AveFont.content)
                            .foregroundStyle(AveColor.content)
                        
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .frame(alignment: .leading)
                }
            }
        } leadingActions: { _ in
        } trailingActions: { context in
            SwipeAction {
                onEdit()
            } label: { highlighted in
                SwipeActionLabel(iconName: "pencil_icon")
                    .opacity(highlighted ? 0.5 : 1)
            } background: { highlighted in
                AveColor.lilac
                    .opacity(highlighted ? 0.5 : 1)
            }
                
            SwipeAction {
                withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                    onDelete()
                }
            } label: { highlighted in
                SwipeActionLabel(iconName: "trash_icon")
                    .opacity(highlighted ? 0.5 : 1)
            } background: { highlighted in
                AveColor.red
                    .opacity(highlighted ? 0.5 : 1)
            }
            .allowSwipeToTrigger()
        }
        .swipeMinimumDistance(10)
        .swipeActionWidth(72)
        .swipeActionsStyle(.equalWidths)
        .swipeActionCornerRadius(16)
        .swipeSpacing(4)
        .swipeActionsMaskCornerRadius(0)
        .swipeActionsVisibleStartPoint(16)
        
        .transition(.swipeDelete)
        .padding(.horizontal, 16)
    }
    
    private var bingoEmojiImage: Image {
        if !model.emoji.isEmpty,
           let uiImage = model.emoji.toUIImage()
        {
            return Image(uiImage: uiImage)
        } else {
            return Image("emoji_example", bundle: .assets)
        }
    }
}

private struct SwipeActionLabel: View {
    let iconName: String
    
    var body: some View {
        Label {
            EmptyView()
        } icon: {
            Image(iconName, bundle: .assets)
        }
    }
}
