//
//  NetworkManager.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/7/24.
//

import Foundation
import RxSwift
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let task = self.session.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodedData))
                } catch {
                    observer(.failure(NetworkError.decodingFail))
                }
                
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func fetchImage(url: URL) -> Single<UIImage> {
        return Single.create { observer in
            let task = self.session.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                guard let image = UIImage(data: data) else {
                    observer(.failure(NetworkError.imageConversionFail))
                    return
                }
                observer(.success(image))
                
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
