//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 10.08.2024.
//

import Foundation
import SwiftUI

public struct PopupErrorView: View {
    @Binding var visible: Bool
    
    public init(visible: Binding<Bool>) {
        _visible = visible
    }
    
    public var body: some View {
        Group {
            if visible {
                HStack(spacing: 16) {
                    Image("error_icon", bundle: .assets)
                    
                    Text("Something went wrong :(")
                        .font(AveFont.content)
                        .foregroundStyle(AveColor.red)
                        .lineLimit(1)
                }
                .padding(.leading, 24)
                .frame(height: 66)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AveColor.redLight)
                }
                .onAppear {
                    Task {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        visible = false
                    }
                }
            }
        }
        .transition(.opacity)
    }
}
