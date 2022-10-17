//
//  MockURLProtocol.swift
//  IncidentsTests
//
//  Created by bindu.ojha on 18/10/22.
//

import Foundation

class MockURLProtocol: URLProtocol{
    
    static var stubResponse: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponse ?? Data())
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
