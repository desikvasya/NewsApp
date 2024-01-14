//
//  NewsModel.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import Foundation

// MARK: - News
struct News: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let articleID: String
    let title: String
    let link: String
    let description: String?
    let pubDate: String
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title, link, description, pubDate
        case imageURL = "image_url"
    }
}

enum Country: String, Codable {
    case argentina = "argentina"
    case bosniaAndHerzegovina = "bosnia and herzegovina"
    case turkey = "turkey"
    case unknown = "unknown"
}

enum Language: String, Codable {
    case bosnian = "bosnian"
    case spanish = "spanish"
    case turkish = "turkish"
    case unknown = "unknown"
}

enum SourceID: String, Codable {
    case aksam = "aksam"
    case elinformador = "elinformador"
    case haberBa = "haber_ba"
    case unknown = "unknown"
}

// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
