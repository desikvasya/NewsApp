//
//  APICaller.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsdata.io/api/1/news?apikey=pub_36334567db4fd6971a9c32df0eb8281a006d3")
    }
    
    public func getTopNews(completion: @escaping (Swift.Result<News, Error>) -> Void) {

        guard let url = Constants.topHeadLinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(News.self, from: data)
                    completion(.success(result))
                    print(result.results.count)
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

