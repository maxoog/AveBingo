//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 07.08.2024.
//

import Foundation
import SwiftUI
import SharedUI

struct AveNavigationLink<Item>: View {
    @Binding var item: Item?
    let destination: (Item) -> AnyView
    
    var body: some View {
        NavigationLink(
            isActive: .init(get: {
                item != nil
            }, set: { active in
                if !active {
                    item = nil
                }
            })) {
                if let item {
                    destination(item)
                }
            } label: {
                EmptyView()
            }
    }
}
