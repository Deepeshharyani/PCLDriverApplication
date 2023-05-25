//
//  NetworkLayerClient.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/2/23.
//

import Foundation

enum ResponseResult: Codable{
    case success(DriverAuthentication)
    case failure(String)
}
enum LoginResponseResult: Codable{
    case success(LoginResponse)
    case failure(String)
}

enum ResultResponseEnum: Codable {
    case success(ResultResponse)
    case failure(String)
}

enum RouteResultEnum : Codable{
    case success(routeDetails)
    case failure(String)
}

protocol ClientNetworkProtocol{
    func driverLogin(phoneNumber: String, password: String,completionHandler: @escaping (LoginResponseResult) ->())
    func driverSignUp(phoneNumber: String, password: String, confirmPassword: String, completionHandler: @escaping (ResponseResult) -> ())
    func requestGetRoute(completionHandler: @escaping (RouteResultEnum) ->())
}

class ClientNetwork: ClientNetworkProtocol{
    
    let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func driverLogin(phoneNumber: String, password: String,completionHandler: @escaping (LoginResponseResult) ->()){
        let Url = String(format: Constants.Url.driverLoginUrl)
        guard let url = URL(string: Url) else {
            return }
        let body : [String : Any] = [
            "Password" : password,
            "PhoneNumber" : phoneNumber
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body,
                                                      options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            print("failed to convert body")
        }
        
        network.requestData(urlRequest: request) { loginResult in
            switch loginResult{
            case .success(let loginData):
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(LoginResponse.self, from: loginData)
                    completionHandler(.success(result))
                }catch{
                    completionHandler(.failure("Decoding Failed"))
                }
                
            case .failure(_):
                completionHandler(.failure("Network Error"))
            }
        }
    }
    func driverSignUp(phoneNumber: String, password: String, confirmPassword: String, completionHandler: @escaping (ResponseResult) -> ()){
        let Url = String(format: Constants.Url.driverSignUpUrl)
        
        guard let url = URL(string: Url) else {
            completionHandler(.failure("Incorrect URL"))
            return
        }
        
        let body: [String: Any] = [
            "ConfirmPassword" : confirmPassword,
            "Password": password,
            "PhoneNumber": phoneNumber
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: body,options: .prettyPrinted)
            request.httpBody = jsonData
        }catch{
            completionHandler(.failure("Header JSON failed"))
        }
        
        network.requestData(urlRequest: request) { signUpResult in
            switch signUpResult{
            case .success(let signUpData):
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(DriverAuthentication.self, from: signUpData)
                    completionHandler(.success(result))
                }catch{
                    completionHandler(.failure("Decoding Error"))
                }
                
            case .failure(_):
                completionHandler(.failure("Network Error"))
            }
            
        }
    }
    
    func requestGetRoute(completionHandler: @escaping (RouteResultEnum) ->()){
        
        let Url = String(format: Constants.Url.getRouteUrl)
        
        guard let url = URL(string: Url) else {
            completionHandler(.failure("URL Error"))
            return
        }
        
        var request = URLRequest(url: url)
        network.requestData(urlRequest: request) { networkResult in
            switch networkResult{
            case .success(let routeData):
                let decoder = JSONDecoder()
                do{
                    let resultGetRoute = try decoder.decode(routeDetails.self, from: routeData)
                    completionHandler(.success(resultGetRoute))
                }catch{
                    completionHandler(.failure("Decoding Error"))
                }
            case .failure(_):
                completionHandler(.failure("Network Error"))
            }
            
        }
    }
    func requestgetRouteDetails(RouteNumber: Int, completionHandler: @escaping(RouteResultEnum) -> ()){
        var Url = String(format: Constants.Url.getRouteDetailUrl)
        Url += "/?RouteNumber=\(RouteNumber)"
        
        guard let url = URL(string: Url) else {
            completionHandler(.failure("URL Error"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        network.requestData(urlRequest: request) { routeResultResult in
            switch routeResultResult{
            case .success(let routeData):
                let decoder = JSONDecoder()
                do{
                    let route = try decoder.decode([routeDetails].self, from: routeData)
                    if let f = route.first {
                        completionHandler(.success(f))
                    } else {
                        completionHandler(.failure("no data found"))
                    }
                    
                }catch{
                    completionHandler(.failure("Decoding Error"))
                }
                
            case .failure(_):
                completionHandler(.failure("Network Error"))
            }
            
        }
    }
    func requestAddTransaction(CustomerId: Int,NumberOfSpecimens: Int,RouteId: Int,Status: Int,UpdateBy: String, completionHandler: @escaping (ResultResponseEnum) -> ()){
        let Url = String(format: Constants.Url.addTransactionUrl)
        guard let url = URL(string: Url) else {
            return }
        let body: [String: Any] = [
            "CustomerId": CustomerId,
            "NumberOfSpecimens": NumberOfSpecimens,
            "RouteId": RouteId,
            "Status": Status,
            "UpdateBy": UpdateBy
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body,
                                                      options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            print("failed to convert body")
        }
        network.requestData(urlRequest: request) { networkResult in
            switch networkResult{
            case .success(let data):
                let decoder = JSONDecoder()
                do{
                    let resultTransaction = try decoder.decode(ResultResponse.self, from: data)
                    completionHandler(.success(resultTransaction))
                }catch{
                    completionHandler(.failure("Decoding Error"))
                }
            case .failure(_):
                completionHandler(.failure("Network Error"))
            }
        }
    }
}
