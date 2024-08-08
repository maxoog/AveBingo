//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 07.08.2024.
//

import Foundation
import SwiftUI
import SharedUI

struct AveNavigationLink<Value: Hashable>: View {
    @Binding
    var currentValueContent: (Value, AnyView)?

    let value: Value?
    let destinations: (Value?) -> AnyView
    
    var body: some View {
        if let value, value.hashValue != currentValueContent?.0.hashValue {
            currentValueContent = (value, destinations(value))
        }
        
        return NavigationLink(
            isActive: .init(get: {
                currentValueContent != nil
            }, set: { active in
                if !active {
                    currentValueContent = nil
                }
            })) {
                currentValueContent?.1 ?? AnyView(EmptyView())
            } label: {
                EmptyView()
            }
    }
}
