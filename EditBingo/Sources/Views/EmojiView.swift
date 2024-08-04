//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 03.08.2024.
//

import Foundation
import SwiftUI
import Resources
import SharedUI

struct EmojiView: View {
    var body: some View {
        Image("emoji_placeholder", bundle: .assets)
            .resizable()
            .frame(width: 56, height: 56)
            .padding(22)
            .background {
                AveColor.backgroundLight
                    .clipShape(Circle())
            }
    }
}
