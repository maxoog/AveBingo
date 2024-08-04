//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 04.08.2024.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct BoolStaticState {
    private var storage: BoolStorage = .init(value: false)
    
    public init() {}
    
    public var wrappedValue: Bool {
        get {
            storage.value
        }
        nonmutating set {
            storage.value = newValue
        }
    }
}

private final class BoolStorage {
    init(value: Bool) {
        self.value = value
    }
    
    var value: Bool
}
