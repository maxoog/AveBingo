//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 03.08.2024.
//

import Foundation
import SwiftUI
import SharedUI

struct TitleTextField: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Name")
                .font(AveFont.content2)
                .foregroundStyle(AveColor.content)
            
            TextField(
                text: $text,
                prompt: Text("Type name")
                    .font(AveFont.content2).foregroundColor(AveColor.secondaryContent),
                label: {}
            )
            .font(AveFont.content2)
            .foregroundStyle(AveColor.content)
            .tint(.black)
            .frame(minWidth: 200, alignment: .center)
            .padding(.vertical, 16)
            .padding(.leading, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                AveColor.backgroundLight
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .contentShape(Rectangle())
        }
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        TitleTextField(text: .init(get: {
            ""
        }, set: { _ in
            
        }))
    }
}
