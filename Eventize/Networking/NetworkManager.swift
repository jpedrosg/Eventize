//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import UIKit

/// An enumeration representing network-related errors that can occur during network operations.
enum NetworkError: Error {
    
    /// Indicates that the provided URL is invalid.
    case invalidURL
    
    /// Represents a network error with an associated underlying error.
    ///
    /// - Parameter error: The underlying error that caused the network error.
    case networkError(Error)
    
    /// Indicates that the response received from the network is invalid or unexpected.
    case invalidResponse
    
    /// Indicates an error while parsing data received from the network.
    case dataParsingError
}

/// Represents the structure of the API endpoints.
enum APIEndpoint {
    /// The default scheme for API endpoints.
    static let defaultScheme = "https"
    
    /// The default host for API endpoints.
    static let defaultHost = "eventize-api-6bd6089a59f0.herokuapp.com"

    // MARK: Events
    
    enum Events {
        static let path = "/events"
    }
    
    enum Event {
        static func path(_ eventUuid: Int) -> String {
            "/events/\(eventUuid)"
        }
    }
    
    enum Tickets {
        static let path = "/tickets"
    }
    
    enum ValidateTicket {
        static func path(_ eventUuid: Int) -> String {
            "/tickets/validar/\(eventUuid)"
        }
    }
}

/// A utility for performing network operations such as fetching data and images.
struct NetworkManager {
    static func createURL(path: String, queryParameters: [String: String]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = APIEndpoint.defaultScheme
        components.host = APIEndpoint.defaultHost
        components.path = path
        if let queryParameters {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url
    }
    
    /// Fetches an image from a given URL.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to fetch.
    ///   - callerName: The name of the calling class or component.
    ///   - completion: A closure to handle the result of the image fetch operation.
    ///                        It provides a `Result` object containing either a `UIImage` or a `NetworkError`.
    static func fetchImage(from url: URL, callerName: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                let networkError = NetworkError.networkError(error)
                LogError.log(.genericError(error: networkError), className: callerName)
                completion(.failure(networkError))
                return
            }
            
            guard let data = data else {
                let invalidResponseError = NetworkError.invalidResponse
                LogError.log(.genericError(error: invalidResponseError), className: callerName)
                completion(.failure(invalidResponseError))
                return
            }
            
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                let invalidResponseError = NetworkError.invalidResponse
                LogError.log(.genericError(error: invalidResponseError), className: callerName)
                completion(.failure(invalidResponseError))
            }
        }.resume()
    }
    
    /// Fetches data from a given URL and decodes it into a specified type.
    ///
    /// - Parameters:
    ///   - url: The URL from which to fetch data.
    ///   - responseType: The type to which the data should be decoded.
    ///   - callerName: The name of the calling class or component.
    ///   - completion: A closure to handle the result of the data fetch and decoding operation.
    ///                        It provides a `Result` object containing either the decoded data or a `NetworkError`.
    static func fetchData<T>(from url: URL, responseType: T.Type, callerName: String, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                let networkError = NetworkError.networkError(error)
                LogError.log(.genericError(error: networkError), className: callerName)
                completion(.failure(networkError))
                return
            }
            
            guard let data = data else {
                let invalidResponseError = NetworkError.invalidResponse
                LogError.log(.genericError(error: invalidResponseError), className: callerName)
                completion(.failure(invalidResponseError))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let decodingError as DecodingError {
                handleDecodingError(decodingError, callerName: callerName, completion: completion)
            } catch {
                let genericError = NetworkError.dataParsingError
                LogError.log(.genericError(error: genericError), className: callerName)
                completion(.failure(genericError))
            }
        }.resume()
    }
    
    /// Fetches data from a given JSON data and decodes it into a specified type.
    ///
    /// - Parameters:
    ///   - jsonData: The JSON data to be decoded.
    ///   - responseType: The type to which the data should be decoded.
    ///   - callerName: The name of the calling class or component.
    ///   - completion: A closure to handle the result of the data decoding operation.
    ///                        It provides a `Result` object containing either the decoded data or a `NetworkError`.
    static func fetchData<T: Decodable>(jsonData: Data, responseType: T.Type, callerName: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let decodedResponse = try decodeResponse(responseType, from: jsonData, callerName: callerName)
            completion(.success(decodedResponse))
        } catch let decodingError as DecodingError {
            handleDecodingError(decodingError, callerName: callerName, completion: completion)
        } catch {
            let genericError = NetworkError.dataParsingError
            LogError.log(.genericError(error: genericError), className: callerName)
            completion(.failure(genericError))
        }
    }
    
    // MARK: - Private Methods
    
    private static func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data, callerName: String) throws -> T {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.dataDecodingStrategy = .deferredToData
        return try jsonDecoder.decode(type, from: data)
    }
    
    private static func handleDecodingError<T: Decodable>(_ error: DecodingError, callerName: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        switch error {
        case .dataCorrupted(let context):
            LogError.log(.dataCorrupted(context: context), className: callerName)
            
        case .keyNotFound(let key, let context):
            LogError.log(.keyNotFound(key: key, context: context), className: callerName)
            
        default:
            LogError.log(.decodingError(error: error), className: callerName)
        }
        
        completion(.failure(NetworkError.dataParsingError))
    }
}
