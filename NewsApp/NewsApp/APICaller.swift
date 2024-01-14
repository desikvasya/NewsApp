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
        static let apiKey = "pub_36334567db4fd6971a9c32df0eb8281a006d3"
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
