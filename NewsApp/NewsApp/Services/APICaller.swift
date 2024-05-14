//
//  APICaller.swift
//  NewsApp
//
//  Created by Eren Aşkın on 12.05.2024.
//

import Foundation

final class APICaller{
    
    static let shared = APICaller()

    private init(){}
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else { return }
        let task = URLSession.shared.dataTask(with: url){ data, _ , error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print(result.articles.count)
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String,completion: @escaping (Result<[Article],Error>) -> Void){
        let urlString = Constants.searchURLString + query
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url){ data, _ , error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print(result.articles.count)
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}
