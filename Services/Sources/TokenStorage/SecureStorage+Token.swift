import Foundation
import SwiftUI

extension SecureStorage {
    func addToken(_ token: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = tokenKey
        query[kSecValueData] = token.data(using: .utf8)

        do {
            try addItem(query: query)
        } catch {
            return
        }
    }

    func updateToken(_ token: String) {
        guard getToken() != nil else {
            addToken(token)
            return
        }

        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = tokenKey

        var attributesToUpdate: [CFString: Any] = [:]
        attributesToUpdate[kSecValueData] = token.data(using: .utf8)

        do {
            try updateItem(query: query, attributesToUpdate: attributesToUpdate)
        } catch {
            return
        }
    }

    func getToken() -> String? {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = tokenKey

        var result: [CFString: Any]?

        do {
            result = try findItem(query: query)
        } catch {
            return nil
        }

        if let data = result?[kSecValueData] as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    func deleteToken() {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = tokenKey

        do {
            try deleteItem(query: query)
        } catch {
            return
        }
    }
}

@propertyWrapper
struct Token: DynamicProperty {
    private let storage = SecureStorage()

    init() {}

    var wrappedValue: String? {
        get { storage.getToken() }
        nonmutating set {
            if let newValue {
                storage.updateToken(newValue)
            } else {
                storage.deleteToken()
            }
        }
    }
}
