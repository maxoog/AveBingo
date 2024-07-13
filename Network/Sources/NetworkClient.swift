import Alamofire
import Foundation

final class Evaluator: ServerTrustEvaluating {
    func evaluate(_ trust: SecTrust, forHost host: String) throws {
        // does not throw
    }
}

public class NetworkClient: SessionDelegate {
    private let address: String = "51.250.105.228"

    public var host: String {
        "https://\(address):8080"
    }
    
    public lazy var session: Session = {
        let evaluator: ServerTrustEvaluating
        
        let trustManager = ServerTrustManager(
            evaluators: [
                address: DisabledTrustEvaluator()
            ]
        )

        let session = Session(
            delegate: self,
            interceptor: RequestInterceptor(),
            serverTrustManager: trustManager
        )
        return session
    }()
}

final class RequestInterceptor: Alamofire.RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
