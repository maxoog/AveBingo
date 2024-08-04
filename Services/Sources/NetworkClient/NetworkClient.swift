import Alamofire
import Foundation
import NetworkCore
import TokenStorage

final class Evaluator: ServerTrustEvaluating {
    func evaluate(_ trust: SecTrust, forHost host: String) throws {
        // does not throw
    }
}

public class NetworkClient: SessionDelegate {
    private let tokenLoader: TokenLoader = TokenLoader()
    
    public var host: String {
        NetworkConstants.apiBaseAddress
    }
    
    public lazy var session: Session = {
        let evaluator: ServerTrustEvaluating
        
        let trustManager = ServerTrustManager(
            evaluators: [
                "avebingo.com": DisabledTrustEvaluator()
            ]
        )

        let session = Session(
            delegate: self,
            interceptor: RequestInterceptor(tokenLoader: tokenLoader),
            serverTrustManager: trustManager
        )
        return session
    }()
}

final class RequestInterceptor: Alamofire.RequestInterceptor {
    let tokenLoader: TokenLoader
    
    init(tokenLoader: TokenLoader) {
        self.tokenLoader = tokenLoader
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(tokenLoader.loadedToken, forHTTPHeaderField: "x-api-key")

        completion(.success(urlRequest))
    }
}

extension DataRequest {
    public func decodable<Value: Decodable>() async throws -> Value {
        let data = try await serializingData().value
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let object = try decoder.decode(Value.self, from: data)

        return object
    }
}
