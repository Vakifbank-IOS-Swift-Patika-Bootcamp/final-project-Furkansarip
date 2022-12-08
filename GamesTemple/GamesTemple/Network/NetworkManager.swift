//
//  NetworkManager.swift
//  GamesTemple
//
//  Created by Furkan Sarı on 6.12.2022.
//

import Foundation

struct NetworkManager {
    private let baseURL = "https://api.rawg.io/api/games?"
    private let API_KEY = "a36ad3f9050f4638861aa23a1284c34c"
    static let shared = NetworkManager()
    private init(){}
    
    func getAllGames(page:Int,completion:@escaping(_ result:Result<GameResponse,ErrorModel>)->Void){
        let endpoint = "\(baseURL)key=\(API_KEY)&page=\(page)"
        print(endpoint)
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                print("error")
                return
            }
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode(GameResponse.self, from: data)
                completion(.success(games))
            }catch{
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
}
