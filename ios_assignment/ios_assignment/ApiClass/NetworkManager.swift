//
//  NetworkManager.swift
//  ios_assignment
//
//  Created by Aditya on 17/04/24.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    func sendRequest(_ request: RequestProtocol, completion: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request.urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])))
                    return
                }
                
                completion(.success(data))
            }
        }
        task.resume()
    }
}
