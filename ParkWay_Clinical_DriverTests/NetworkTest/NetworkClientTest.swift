//
//  NetworkClientTest.swift
//  ParkWay_Clinical_DriverTests
//
//  Created by Deepesh Haryani on 4/23/23.
//

import Foundation
@testable import ParkWay_Clinical_Driver
import XCTest

final class MockNetwork: NetworkProtocol{
    var mockData: [String : Data] = [:]
    func requestData(urlRequest: URLRequest, completionHandler: @escaping (NetworkResult) -> ()) {
        if let urlString = urlRequest.url?.absoluteString,
           let data = mockData[urlString] {
            completionHandler( .success(data))
            return
        }
        completionHandler(.failure("Failure"))
    }
    
    func setMockData(url: String, data: Data){
        mockData[url] = data
    }
}
