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
    let keywords, creator: [String]?
    let videoURL: JSONNull?
    let description, content: String?
    let pubDate: String
    let imageURL: String?
    let sourceID: SourceID
    let sourcePriority: Int
    let country: [Country]
    let category: [Category]?
    let language: Language
    let aiTag: AITag
    let sentiment, sentimentStats: AITag?
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title, link, keywords, creator
        case videoURL = "video_url"
        case description, content, pubDate
        case imageURL = "image_url"
        case sourceID = "source_id"
        case sourcePriority = "source_priority"
        case country, category, language
        case aiTag = "ai_tag"
        case sentiment
        case sentimentStats = "sentiment_stats"
    }
}


enum AITag: Codable {
    case single(String)
    case multiple([String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            let stringValue = try container.decode(String.self)
            self = .single(stringValue)
        } catch DecodingError.typeMismatch {
            let arrayValue = try container.decode([String].self)
            self = .multiple(arrayValue)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .single(let stringValue):
            try container.encode(stringValue)
        case .multiple(let arrayValue):
            try container.encode(arrayValue)
        }
    }
}



enum Category: String, Codable {
    case entertainment = "entertainment"
    case top = "top"
    case unknown = "unknown"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        if let category = Category(rawValue: rawValue) {
            self = category
        } else {
            self = .unknown
        }
    }
}


enum Country: String, Codable {
    case argentina = "argentina"
    case bosniaAndHerzegovina = "bosnia and herzegovina"
    case turkey = "turkey"
    case unknown = "unknown"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        if let country = Country(rawValue: rawValue) {
            self = country
        } else {
            self = .unknown
        }
    }
}


enum Language: String, Codable {
    case bosnian = "bosnian"
    case spanish = "spanish"
    case turkish = "turkish"
    case unknown = "unknown"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        if let language = Language(rawValue: rawValue) {
            self = language
        } else {
            self = .unknown
        }
    }
}


extension DateFormatter {
    static let customDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

enum PubDate: String, Codable {
    case the20240112081626 = "2024-01-12 08:16:26"
    case the20240112081652 = "2024-01-12 08:16:52"
    case the20240112081815 = "2024-01-12 08:18:15"
}

enum SourceID: String, Codable {
    case aksam = "aksam"
    case elinformador = "elinformador"
    case haberBa = "haber_ba"
    case unknown = "unknown"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        if let sourceID = SourceID(rawValue: rawValue) {
            self = sourceID
        } else {
            self = .unknown
        }
    }
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
