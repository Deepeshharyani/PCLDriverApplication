//
//  Constant.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/8/23.
//

import Foundation

struct routeDetails: Codable{
    var Route: RouteResponse
    var Customer: [CustomerResponse]
}
struct RouteResponse: Codable{
    var RouteNo: Int
    var RouteName: String
    var DriverId: Int
    var VehicleNo: String
}
struct CustomerResponse: Codable{
    var CustomerId: Int
    var CustomerName: String
    var StreetAddress: String
    var City: String
    var State: String
    var Zip: String
    var PickUpTime: String
    var SpecimensCollected: Int
    var CollectionStatus: String
    var IsSelected: Bool
    var Cust_Lat: Double
    var Cust_Log: Double
}

struct LoginResponse: Codable {
    var RouteNo: Int
}
struct ResultResponse: Codable {
    var Result: String
}
