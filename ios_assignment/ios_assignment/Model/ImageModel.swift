//
//  ImageModel.swift
//  ios_assignment
//
//  Created by Aditya on 17/04/24.
//

import Foundation
struct ImageModel : Codable {
    let id : String?
    let title : String?
    let language : String?
    let thumbnail : Thumbnail?
    let mediaType : Int?
    let coverageURL : String?
    let publishedAt : String?
    let publishedBy : String?
    let backupDetails : BackupDetails?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case language = "language"
        case thumbnail = "thumbnail"
        case mediaType = "mediaType"
        case coverageURL = "coverageURL"
        case publishedAt = "publishedAt"
        case publishedBy = "publishedBy"
        case backupDetails = "backupDetails"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        mediaType = try values.decodeIfPresent(Int.self, forKey: .mediaType)
        coverageURL = try values.decodeIfPresent(String.self, forKey: .coverageURL)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
        publishedBy = try values.decodeIfPresent(String.self, forKey: .publishedBy)
        backupDetails = try values.decodeIfPresent(BackupDetails.self, forKey: .backupDetails)
    }

}
struct BackupDetails : Codable {
    let pdfLink : String?
    let screenshotURL : String?

    enum CodingKeys: String, CodingKey {

        case pdfLink = "pdfLink"
        case screenshotURL = "screenshotURL"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pdfLink = try values.decodeIfPresent(String.self, forKey: .pdfLink)
        screenshotURL = try values.decodeIfPresent(String.self, forKey: .screenshotURL)
    }

}
struct Thumbnail : Codable {
    let id : String?
    let version : Int?
    let domain : String?
    let basePath : String?
    let key : String?
    let qualities : [Int]?
    let aspectRatio : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case version = "version"
        case domain = "domain"
        case basePath = "basePath"
        case key = "key"
        case qualities = "qualities"
        case aspectRatio = "aspectRatio"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        version = try values.decodeIfPresent(Int.self, forKey: .version)
        domain = try values.decodeIfPresent(String.self, forKey: .domain)
        basePath = try values.decodeIfPresent(String.self, forKey: .basePath)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        qualities = try values.decodeIfPresent([Int].self, forKey: .qualities)
        aspectRatio = try values.decodeIfPresent(Double.self, forKey: .aspectRatio)
    }

}
