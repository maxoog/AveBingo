import SwiftUI

/// Property Wrapper, который хранит слабую ссылку
/// на какой-то объект и сообщает View об изменении этой ссылки.

@propertyWrapper
public struct WeakState<Value: AnyObject>: DynamicProperty {
    @State private var valueReference = WeakReference<Value>(value: nil)

    public init() {}

    public var wrappedValue: Value? {
        get {
            valueReference.value
        }
        nonmutating set {
            valueReference.value = newValue
        }
    }
}

private struct WeakReference<Value: AnyObject> {
    weak var value: Value?
}

