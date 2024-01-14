//
//  APICaller.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import Foundation

struct APIResponse: Codable {
    let status: String
    let totalResults: Int?
    let results: [Result]
    let nextPage: String?
}

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let apiKey = "pub_364116a4888998ad07cc98a053a997b112314"
        static let topHeadlinesURL = URL(string: "https://newsdata.io/api/1/news")
    }
    
    func getTopNews(page: String?, completion: @escaping (Swift.Result<APIResponse, Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: Constants.apiKey)
        ]
        
        if let page = page {
            queryItems.append(URLQueryItem(name: "page", value: page))
        }
        
        components.queryItems = queryItems
        
        guard let requestURL = components.url else { return }
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
