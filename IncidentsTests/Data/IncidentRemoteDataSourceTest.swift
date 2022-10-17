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
    
    override func setUpWithError() throws {
        config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
    }

    override func tearDownWithError() throws {
        config = nil
        urlSession = nil
    }

    func testRemoteDataSource_WhenGivenValidUrl_ReturnsValidData(){
        
        // Arrange
       // let config = URLSessionConfiguration.ephemeral
        //config.protocolClasses = [MockURLProtocol.self]
       // let urlSession = URLSession(configuration: config)
        
        MockURLProtocol.stubResponse = MockData.data1.data(using: .utf8)
        let sut = IncidentRemoteDataSource(urlString: "https://dummy.com", urlSession: urlSession)
        
        // Act
        sut.getIncidents { result in
            switch(result){
            case .success(let dataModel):
                
                // Assert
               // print( dataModel.first!.status)
                XCTAssertEqual(dataModel.first!.status, "On cene")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func testRemoteDataSource_WhenGivenInvalidUrl_ReturnsInvalidUrl(){
        // Arrange
        MockURLProtocol.stubResponse = MockData.data1.data(using: .utf8)
        
        let sut = IncidentRemoteDataSource(urlString: "InvalidUrl.com", urlSession: urlSession)
        
        // Act
        sut.getIncidents { result in
            switch(result){
            case .failure(let error):
                // Assert
                //print(error.localizedDescription)
                XCTAssertEqual(error.localizedDescription, "Invalid URL string")
            default:()
            }
        }
    }
}
