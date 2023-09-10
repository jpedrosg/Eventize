//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

/// An enumeration representing various types of errors related to logging and decoding.
enum LogError {
    
    /// Indicates a data corruption error during decoding.
    ///
    /// - Parameter context: The context information associated with the data corruption error.
    case dataCorrupted(context: DecodingError.Context)
    
    /// Indicates a key not found error during decoding.
    ///
    /// - Parameters:
    ///   - key: The coding key that was not found.
    ///   - context: The context information associated with the key not found error.
    case keyNotFound(key: CodingKey, context: DecodingError.Context)
    
    /// Indicates a general decoding error.
    ///
    /// - Parameter error: The decoding error that occurred.
    case decodingError(error: DecodingError)
    
    /// Indicates a generic error unrelated to decoding.
    ///
    /// - Parameter error: The underlying error that caused the generic error.
    case genericError(error: Error)
    
    /// Logs the provided error with the associated class name.
    ///
    /// - Parameters:
    ///   - error: The error to be logged.
    ///   - className: The name of the class or component where the error occurred.
    static func log(_ error: LogError, className: String) {
        switch error {
        case .dataCorrupted(let context):
            print("\(className) Data Corrupted: \(context.debugDescription)")
            
        case .keyNotFound(let key, let context):
            print("\(className) Key Not Found: \(key.stringValue) in \(context.debugDescription)")
        
        case .decodingError(let error):
            print("\(className) Decoding Error: \(error.localizedDescription)")
            
        case .genericError(let error):
            print("\(className) Generic Error: \(error.localizedDescription)")
        }
    }
}
