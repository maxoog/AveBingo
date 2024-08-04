//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 03.08.2024.
//

import Foundation
import SwiftUI
import SharedUI

struct StylePickerView: View {
    @Binding var sizeSelection: BingoCellStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Style")
                .font(AveFont.content2)
                .foregroundStyle(AveColor.content)
            
            HStack(spacing: 16) {
                ForEach(BingoCellStyle.allCases, id: \.self) { style in
                    BingoStyleView(
                        style: style,
                        selected: sizeSelection == style
                    )
                    .onTapGesture {
                        sizeSelection = style
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct BingoStyleView: View {
    let style: BingoCellStyle
    let selected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(style.previewImageName, bundle: .assets)
                .resizable()
                .frame(width: 62, height: 62)
                .padding(9)
                .overlay {
                    if selected {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AveColor.content)
                    }
                }

            Text(style.rawValue.capitalized)
                .font(AveFont.content2)
                .foregroundStyle(AveColor.content)
        }
        .contentShape(Rectangle())
    }
}


struct Preview: PreviewProvider {
    static var previews: some View {
        StylePickerView(sizeSelection: .constant(.basic))
    }
}
