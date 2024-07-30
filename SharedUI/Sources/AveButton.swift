//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 27.07.2024.
//

import Foundation
import SwiftUI
import Resources

public struct AveButton: View {
    private let iconName: String
    private let text: String
    private let onTap: () -> Void
    
    public init(iconName: String, text: String, onTap: @escaping () -> Void) {
        self.iconName = iconName
        self.text = text
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap, label: {
            HStack(spacing: 12) {
                Image(iconName, bundle: .assets)
                
                Text(text)
                    .font(AveFont.content)
                    .foregroundStyle(Color.white)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 48)
            .background {
                AveColor.contentLight
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            }
        })
    }
}
