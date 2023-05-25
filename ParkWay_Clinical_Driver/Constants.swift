//
//  Constants.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/2/23.
//

import Foundation


struct Constants {
    struct Url{
        static let driverLoginUrl = "https://pclwebapi.azurewebsites.net/api/Driver/DriverLogin"
        static let driverSignUpUrl = "https://pclwebapi.azurewebsites.net/api/Driver/DriverSignUp"
        static let getDriverUrl = "https://pclwebapi.azurewebsites.net/api/Driver/GetDriver"
        static let getRouteUrl = "https://pclwebapi.azurewebsites.net/api/Route/GetRoute"
        static let getRouteDetailUrl = "https://pclwebapi.azurewebsites.net/api/Route/GetRouteDetail"
        static let addTransactionUrl = "https://pclwebapi.azurewebsites.net/api/Admin/AddUpdateTransactionStatus"
    }
}
