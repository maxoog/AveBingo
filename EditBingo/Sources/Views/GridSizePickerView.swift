//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 03.08.2024.
//

import Foundation
import SwiftUI
import SharedUI
import Resources

struct GridSizePickerView: View {
    @Binding var sizeSelection: BingoGridSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Grid")
                .font(AveFont.content2)
                .foregroundStyle(AveColor.content)
            
            HStack(spacing: 8) {
                ForEach(BingoGridSize.allCases, id: \.rawValue) { size in
                    SizePickerButton(size: size, currentSize: sizeSelection)
                        .onTapGesture {
                            sizeSelection = size
                        }

                }
            }
        }
        .animation(.easeInOut(duration: 0.1), value: sizeSelection)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SizePickerButton: View {
    let size: BingoGridSize
    let currentSize: BingoGridSize
    
    var body: some View {
        HStack(spacing: 8) {
            if chosen {
                Image("check_circle_icon", bundle: .assets)
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            
            Text(size.rawValue)
                .font(AveFont.content2)
        }
        .foregroundStyle(chosen ? .white : AveColor.content)
        .padding(.horizontal, 24)
        .frame(height: 51)
        .background {
            (chosen ?  AveColor.content : AveColor.backgroundLight)
                .clipShape(RoundedRectangle(cornerRadius: 40))
        }
    }
    
    private var chosen: Bool {
        return size == currentSize
    }
}
