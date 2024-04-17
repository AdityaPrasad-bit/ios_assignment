//
//  ViewModel.swift
//  ios_assignment
//
//  Created by Aditya on 17/04/24.
//

import Foundation
protocol ViewModelDelegate {
    func didLoadData()
    func didFailData(errorData:String)
}
class ViewModel{
    var delegate:ViewModelDelegate!
    var rawData:Data?
    func callApi(page:Int){
        NetworkManager.shared.sendRequest(APIService.getMediaCoverages(page)) { result in
            switch result {
            case .success(let data):
                self.rawData = data
                // Handle successful response with data
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
                self.delegate.didLoadData()
            case .failure(let error):
                // Handle the error
                print("Error: \(error.localizedDescription)")
                self.delegate.didFailData(errorData: error.localizedDescription)
            }
        }
    }
}
