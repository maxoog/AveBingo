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

struct BingoSnippetView: View {
    let model: BingoModel
    
    @State var showingStylesSwipeToDelete: Bool = true
    
    var body: some View {
        if showingStylesSwipeToDelete {
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
            } trailingActions: { _ in
                SwipeAction {
                    
                } label: { _ in
                    Label {
                        EmptyView()
                    } icon: {
                        Image("pencil_icon", bundle: .assets)
                    }
                } background: { _ in
                    AveColor.lilac
                }
                
                SwipeAction {
                    withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                        showingStylesSwipeToDelete = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 1)) {
                            showingStylesSwipeToDelete = true
                        }
                    }
                } label: { _ in
                    Label {
                        EmptyView()
                    } icon: {
                        Image("trash_icon", bundle: .assets)
                    }
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
}
