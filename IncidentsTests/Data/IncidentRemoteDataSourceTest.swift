//
//  IncidentRemoteDataSourceTest.swift
//  IncidentsTests
//
//  Created by bindu.ojha on 18/10/22.
//

import XCTest
@testable import Incidents

class IncidentRemoteDataSourceTest: XCTestCase {

    var config: URLSessionConfiguration!
    var urlSession: URLSession!
    let urlString = "https://run.mocky.io/v3/5e90b420-388e-4913-b240-b5326823212c"
    
    override func setUpWithError() throws {
        config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
    }

    override func tearDownWithError() throws {
        config = nil
        urlSession = nil
    }

    private func getJSONData(from resource: String)->Data?{
        var data: Data?
        if let file = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json") {
            data = try! Data(contentsOf: file)
        }
        return data
    }
    
    func testRemoteDataSource_WhenGivenSuccessfulResponse_ReturnsSuccess(){
        
        // Arrange
        MockURLProtocol.stubResponse = getJSONData(from: "ValidResponse")
        let sut = IncidentRemoteDataSource(urlString: urlString, urlSession: urlSession)
        let expectation = self.expectation(description: "testRemoteDataSourceWhenGivenValidUrlReturnsValidData")
        // Act
        sut.getIncidents { result in
            switch(result){
            case .success(let dataModel):
                // Assert
                XCTAssertEqual(dataModel.first!.status, "On Scene")
                expectation.fulfill()
            default:()
            }
        }
       waitForExpectations(timeout: 5)
    }
    
    func testRemoteDataSource_WhenReceiveDifferentJSONResponse_ReturnsError(){
        // Arrange
        MockURLProtocol.stubResponse = getJSONData(from: "InvalidResponse")
        let sut = IncidentRemoteDataSource(urlString: urlString, urlSession: urlSession)
        let expectation = self.expectation(description: "testRemoteDataSourceWhenGivenValidUrlReturnsValidData")
        // Act
        sut.getIncidents { result in
            switch(result){
            case .failure(let error):
                // Assert
                XCTAssertEqual(NetworkError.DecodingIssue.localizedDescription, error.localizedDescription)
                expectation.fulfill()
            default:()
            }
        }
       waitForExpectations(timeout: 5)
    }
}

