//
//  Driver_API_Test.swift
//  ParkWay_Clinical_DriverTests
//
//  Created by Deepesh Haryani on 4/25/23.
//

import Foundation
@testable import ParkWay_Clinical_Driver
import XCTest


final class DriverAPITest: XCTestCase {
    let mockNetwork = MockNetwork()
    
    
    func testAllDriverAPI_HappyPath() throws {
        let data = try XCTUnwrap(getJson(fileName: "AllDriverHappyPath"), "File not found")
        let urlString = Constants.Url.getRouteDetailUrl + "98"
        mockNetwork.setMockData(url: urlString, data: data)
        
        let client = ClientNetwork(network: mockNetwork)
        client.requestgetRouteDetails(RouteNumber: 98, completionHandler: { model in
            switch model{
            
            case .success(let data):
                XCTAssertNotNil(data)
                    
            case .failure(_):
                XCTFail()
            }
            
        })
    }
}

extension DriverAPITest {
    func getJson(fileName: String) -> Data? {
        let bundle = Bundle(for: DriverAPITest.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  return data
              } catch {
                   return nil
              }
        }
        return nil
    }
}


