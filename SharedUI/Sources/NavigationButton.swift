//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 31.07.2024.
//

import Foundation
import SwiftUI
import Resources

public struct NavigationButton: View {
    let iconName: String
    let onTap: () -> Void

    public init(iconName: String, onTap: @escaping () -> Void) {
        self.iconName = iconName
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            ZStack {
                AveColor.backgroundLight
                    .clipShape(Circle())
                    .frame(width: 44, height: 44)

                Image(iconName, bundle: .assets)
                    .renderingMode(.template)
                    .foregroundStyle(AveColor.content)
            }
        }
    }
}
