//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 04.08.2024.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct StaticState<Value> {
    private let storage: InternalStorage<Value>

    public init(wrappedValue defaultValue: Value) {
        self.storage = .init(value: defaultValue)
    }

    public var wrappedValue: Value {
        get {
            storage.value
        }
        nonmutating set {
            storage.value = newValue
        }
    }
}

private final class InternalStorage<Value> {
    init(value: Value) {
        self.value = value
    }

    var value: Value
}
