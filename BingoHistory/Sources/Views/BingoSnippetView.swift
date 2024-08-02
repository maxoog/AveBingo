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
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        SwipeView {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AveColor.backgroundLight)
                    .frame(height: 72)
                
                HStack(spacing: 16) {
                    Image("emoji_example", bundle: .assets)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .background {
                            AveColor.background
                                .clipShape(Circle())
                                .frame(width: 32, height: 32)
                        }
                    
                    Text("Bingo name")
                        .font(AveFont.content)
                        .foregroundStyle(AveColor.content)
                    
                    Spacer()
                }
                .padding(.leading, 16)
                .frame(alignment: .leading)
            }
        } leadingActions: { _ in
        } trailingActions: { context in
            SwipeAction {
                onEdit()
            } label: { _ in
                SwipeActionLabel(iconName: "pencil_icon")
            } background: { _ in
                AveColor.lilac
            }
            
            SwipeAction {
                withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                    onDelete()
                }
            } label: { _ in
                SwipeActionLabel(iconName: "trash_icon")
            } background: { _ in
                AveColor.red
            }
            .allowSwipeToTrigger()
        }
        .swipeActionWidth(72)
        
        .swipeActionsStyle(.equalWidths)
        .swipeActionCornerRadius(16)
        .swipeSpacing(4)
        .swipeActionsMaskCornerRadius(0)
        
        .swipeActionsVisibleStartPoint(0)
        .swipeActionsVisibleEndPoint(0)
        
        .transition(.swipeDelete)
        .padding(.horizontal, 16)
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
