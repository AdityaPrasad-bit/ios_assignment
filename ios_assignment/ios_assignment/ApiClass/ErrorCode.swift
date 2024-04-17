//
//  ErrorCode.swift
//  ios_assignment
//
//  Created by Aditya on 17/04/24.
//

import Foundation
struct ErrorCode : Codable {
    let code : Int?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
