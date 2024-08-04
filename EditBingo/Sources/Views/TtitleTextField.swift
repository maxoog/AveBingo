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
    let error: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Name")
                .font(AveFont.content2)
                .foregroundStyle(error ? AveColor.red : AveColor.content)
            
            TextField(
                text: $text,
                prompt: Text("Type name")
                    .font(AveFont.content2).foregroundColor(AveColor.secondaryContent),
                label: {}
            )
            .tint(AveColor.content)
            .font(AveFont.content2)
            .foregroundStyle(AveColor.content)
            .tint(.black)
            .frame(height: 51)
            .padding(.leading, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                AveColor.backgroundLight
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .overlay {
                if error {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AveColor.red)
                }
            }
            .contentShape(Rectangle())
        }
    }
}
