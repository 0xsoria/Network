import XCTest
import Network

final class NetworkServiceTests: XCTestCase {
    
    let url = URL(string: "www.apple.com")!
    let urlString = "https://www.apple.com"
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    func testRequestNoThrowsForFiles() async throws {
        let service = MockNetwork(fileName: "QuinaLast")
        let data = try await service.request(url: String())
        XCTAssertNoThrow(data)
    }
    
    func testRequestWithCompletion() {
        let service = MockNetwork(fileName: "QuinaLast")
        let expectation = XCTestExpectation(description: "expect not to fail")
        service.request(url: String()) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let success):
                expectation.fulfill()
                XCTAssertTrue(!success.isEmpty)
            case .failure:
                expectation.fulfill()
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testSuccessfulResponse() {
        let session = URLSessionMock()
        let service = NetworkService(urlSession: session)

        let data = Data([0, 1, 0, 1])
        session.data = data
        let response = HTTPURLResponse(url: URL(string: "www.apple.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        session.response = response
        service.request(url: "www.apple.com") { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let successData):
                XCTAssertTrue(successData == data)
            case .failure(let failure):
                XCTFail("Error \(failure)")
            }
        }
    }
    
    func testFailureNoResponse() {
        let session = URLSessionMock()
        let service = NetworkService(urlSession: session)
        
        session.data = Data()
        service.request(url: "www.apple.com") { (result: Result<Data, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Should not be successful")
            case .failure(let error):
                XCTAssertTrue(error == .noResponse)
            }
        }
    }
    
    func testFailureEmptyData() {
        let session = URLSessionMock()
        let service = NetworkService(urlSession: session)
        
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        session.response = response
        service.request(url: "www.apple.com") { (result: Result<Data, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Should not be successfuk")
            case .failure(let error):
                XCTAssertTrue(error == .noData)
            }
        }
    }
    
    func testFailureStatusCode() {
        let session = URLSessionMock()
        let service = NetworkService(urlSession: session)
        
        let response = HTTPURLResponse(url: url,
                                       statusCode: 400,
                                       httpVersion: nil,
                                       headerFields: nil)
        session.response = response
        service.request(url: urlString) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Should not be successfuk")
            case .failure(let error):
                XCTAssertTrue(error == .responseStatusCode(code: 400))
            }
        }
    }
    
    func testFailureErrorNotNil() {
        let session = URLSessionMock()
        let service = NetworkService(urlSession: session)
        
        let response = HTTPURLResponse(url: url,
                                       statusCode: 400,
                                       httpVersion: nil,
                                       headerFields: nil)
        session.response = response
        let error = NSError(domain: urlString,
                            code: 400,
                            userInfo: nil)
        session.error = error
        service.request(url: urlString) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Should not be successful")
            case .failure(let error):
                XCTAssertTrue(error == .taskError(error: error))
            }
        }
    }
    
    func testInvalidURL() {
        let session = URLSessionMock()
        let service = NetworkService(urlSession: session)
        
        service.request(url: String()) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Should not be successful")
            case .failure(let error):
                XCTAssertTrue(error == .url)
            }
        }
    }
}
