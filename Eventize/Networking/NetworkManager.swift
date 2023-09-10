//
//  Copyright © Uber Technologies, Inc. All rights reserved.
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

/// A utility for performing network operations such as fetching data and images.
struct NetworkManager {
    
    /// Fetches an image from a given URL.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to fetch.
    ///   - callerName: The name of the calling class or component.
    ///   - completion: A closure to handle the result of the image fetch operation.
    ///                        It provides a `Result` object containing either a `UIImage` or a `NetworkError`.
    static func fetchImage(from url: URL, callerName: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        // Reuse the fetchData method to fetch image data
        fetchData(from: url, responseType: Data.self, callerName: callerName) { result in
            switch result {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    completion(.success(image))
                } else {
                    let invalidResponseError = NetworkError.invalidResponse
                    completion(.failure(invalidResponseError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches data from a given URL and decodes it into a specified type.
    ///
    /// - Parameters:
    ///   - url: The URL from which to fetch data.
    ///   - responseType: The type to which the data should be decoded.
    ///   - callerName: The name of the calling class or component.
    ///   - completion: A closure to handle the result of the data fetch and decoding operation.
    ///                        It provides a `Result` object containing either the decoded data or a `NetworkError`.
    static func fetchData<T: Decodable>(from url: URL, responseType: T.Type, callerName: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
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
                let decodedResponse = try decodeResponse(responseType, from: data, callerName: callerName)
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
