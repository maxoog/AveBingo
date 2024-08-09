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
    private let iconName: String?
    private let text: String
    private let isLoading: Bool?
    private let onTap: () -> Void
    
    public init(iconName: String?, text: String, isLoading: Bool? = nil, onTap: @escaping () -> Void) {
        self.iconName = iconName
        self.text = text
        self.isLoading = isLoading
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap, label: {
            HStack(spacing: 12) {
                if let iconName {
                    Image(iconName, bundle: .assets)
                }
                
                if isLoading == true {
                    ProgressView()
                } else {
                    Text(text)
                        .font(AveFont.content)
                        .foregroundStyle(Color.white)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 48)
            .background {
                AveColor.contentLight
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            }
        })
        .animation(.default, value: isLoading)
    }
}
