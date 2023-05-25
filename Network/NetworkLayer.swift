//
//  NetworkLayer.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/2/23.
//

import Foundation
enum NetworkResult: Codable{
    case success(Data)
    case failure(String)
}

protocol NetworkProtocol{
    func requestData(urlRequest: URLRequest, completionHandler: @escaping (NetworkResult) -> ())
}

class Network: NetworkProtocol {
    func requestData(urlRequest: URLRequest, completionHandler: @escaping (NetworkResult) -> ()){
        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                completionHandler(.failure(error.localizedDescription))
                return
            }
            
            if let data = data{
                completionHandler(.success(data))
                return
            }else{
                completionHandler(.failure("Data Not Found"))
                return
            }
        }.resume()
    }
    
}
