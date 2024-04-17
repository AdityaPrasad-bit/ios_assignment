//
//  ApiService.swift
//  ios_assignment
//
//  Created by Aditya on 17/04/24.
//

import Foundation
protocol RequestProtocol {
    var baseURL: URL { get }
    var method: String { get }
    var task: URLSessionDataTask { get }
    var urlRequest: URLRequest { get }
}
enum APIService:RequestProtocol {

    case getMediaCoverages(Int)
    
    var baseURL: URL {
        switch self {
        case .getMediaCoverages(let limit):
            return URL(string: "\(Constant.baseURL)?limit=\(limit)")!
        }
    }
    var method: String {
        switch self {
        case .getMediaCoverages(_):
            return Constant.getMethod
            // Handle other cases
        }
    }
    var task: URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: self.urlRequest) { data, response, error in
            // Handle the response and error here as needed
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Request failed")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(responseString)")
                // Further handling of the response data
            }
        }
        return task
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: baseURL)
        request.httpMethod = method
        return request
    }
}
