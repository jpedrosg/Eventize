//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import XCTest
@testable import Eventize

class NetworkManagerTests: XCTestCase {
    
    // MARK: - Image Fetch Tests
    
    func testFetchImage_WhenValidURLIsProvided_ShouldFetchImage() {
        // Arrange
        let imageUrl = URL(string: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_272x92dp.png")!
        let callerName = "TestCaller"
        var fetchedImage: UIImage?
        var fetchError: NetworkError?
        
        let expectation = self.expectation(description: "Image fetched successfully")
        
        // Act
        NetworkManager.fetchImage(from: imageUrl, callerName: callerName) { result in
            switch result {
            case .success(let image):
                fetchedImage = image
                expectation.fulfill()
            case .failure(let error):
                fetchError = error
                expectation.fulfill()
            }
        }
        
        // Wait for the async operation to complete
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // Assert
        XCTAssertNotNil(fetchedImage)
        XCTAssertNil(fetchError)
    }
    
    func testFetchImage_WhenImageDataIsInvalid_ShouldReturnInvalidResponseError() {
        // Arrange
        let invalidImageUrl = URL(string: "https://example.com/invalid-image.jpg")!
        let callerName = "TestCaller"
        var fetchedImage: UIImage?
        var fetchError: NetworkError?
        
        let expectation = self.expectation(description: "Invalid image data error")
        
        // Act
        NetworkManager.fetchImage(from: invalidImageUrl, callerName: callerName) { result in
            switch result {
            case .success(let image):
                fetchedImage = image
                expectation.fulfill()
            case .failure(let error):
                fetchError = error
                expectation.fulfill()
            }
        }
        
        // Wait for the async operation to complete
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // Assert
        XCTAssertNil(fetchedImage)
        guard case .invalidResponse = fetchError else {
            XCTFail("Expected .dataParsingError error type")
            return
        }
    }
    
    func testFetchData_WithValidData_ShouldDecodeSuccessfully() {
        // Arrange
        let jsonData = """
            {
                "name": "John",
                "age": 30
            }
            """.data(using: .utf8)!
        
        // Act
        NetworkManager.fetchData(jsonData: jsonData, responseType: UserModel.self, callerName: "TestCaller") { result in
            switch result {
            case .success(let user):
                // Assert
                XCTAssertEqual(user.name, "John")
                XCTAssertEqual(user.age, 30)
                
            case .failure(let error):
                XCTFail("Expected successful decoding, but got error: \(error)")
            }
        }
    }
    
    func testFetchData_WithInvalidData_ShouldFailDecoding() {
        // Arrange
        let jsonData = """
            {
                "name": "John"
                // Missing "age" field
            }
            """.data(using: .utf8)!
        
        // Act
        NetworkManager.fetchData(jsonData: jsonData, responseType: UserModel.self, callerName: "TestCaller") { result in
            switch result {
            case .success:
                XCTFail("Expected decoding to fail, but it succeeded.")
                
            case .failure(let error):
                // Assert
                guard case .dataParsingError = error else {
                    XCTFail("Expected .dataParsingError error type")
                    return
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func createJsonData(with jsonString: String) -> Data {
        return jsonString.data(using: .utf8)!
    }
}

// Sample model for testing
struct UserModel: Codable {
    let name: String
    let age: Int
}
