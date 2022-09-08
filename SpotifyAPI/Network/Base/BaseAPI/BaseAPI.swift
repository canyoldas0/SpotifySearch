//
//  BaseAPI.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

import Foundation

enum SessionType {
    case defaultSession
    case mock
}

//class ErrorResponse: Error {
//    let customErrorMesage: String?
//
//    init(errorMessage: String? = nil) {
//        self.customErrorMesage = errorMessage
//    }
//}

class BaseAPI {
    
    private let session: URLSession
    private var jsonDecoder = JSONDecoder()
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    func execute<T>(
        request: URLRequest,
        sessionType: SessionType = .defaultSession,
        dispatchQueue: DispatchQueue = .main,
        completion: @escaping ((Result<T, Error>) -> Void)
    ) where T: Decodable {
        
        switch sessionType {
        case .defaultSession:
            session.dataTask(with: request) { (data, urlResponse, error) in
                self.handleResponse(data, urlResponse, error, dispatchQueue: dispatchQueue, completion: completion)
            }.resume()
        default:
            break /// can implement session configuration according to build settings.
        }
    }
    
    func execute<T>(
        endpoint: String,
        httpMethod: HTTPMethod = .GET,
        requestable: Requestable,
        dispatchQueue: DispatchQueue = .main,
        sessionType: SessionType = .defaultSession,
        completion: @escaping ((Result<T, Error>) -> Void)
    ) where T: Decodable {
        
        createRequest(from: endpoint, for: httpMethod, with: requestable) { [weak self] result in
            
            switch result {
            case .success(let urlRequest):
                switch sessionType {
                case .defaultSession:
                    self?.session.dataTask(with: urlRequest) { (data, urlResponse, error) in
                        self?.handleResponse(data, urlResponse, error, dispatchQueue: dispatchQueue, completion: completion)
                    }.resume()
                default:
                    break /// can implement session configuration according to build settings.
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func handleResponse<T: Decodable>(
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?,
        dispatchQueue: DispatchQueue,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            dispatchQueue.async {
                if error != nil {
                    completion(.failure(error!))
                }
                
                if let data = data {
                    do {
                        let decodedData = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch let error {
                        completion(.failure(NetworkError.decodingFailed))
                    }
                }
            }
        }
    
    private func createRequest(
        from endpoint: String,
        for type: HTTPMethod,
        with requestable: Requestable,
        completion: @escaping ResponseHandler<URLRequest>
    ) {
        AuthManager.shared.withValidToken { [weak self] result in
            guard let url = URL(string: endpoint) else {
                return
            }
            
            switch result {
            case .success(let token):
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    urlComponents.queryItems = requestable.queryItems
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = type.rawValue
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    request.url = urlComponents.url
                    
                    completion(.success(request))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
