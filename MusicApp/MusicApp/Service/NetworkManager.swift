//
//  NetworkManager.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
// 

import Foundation

protocol DataFetcher {
    func fetchModel<T: Decodable>(url: URL?, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
}

extension NetworkManager: DataFetcher {
    
    func fetchModel<T: Decodable>(url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                print(model)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
}
