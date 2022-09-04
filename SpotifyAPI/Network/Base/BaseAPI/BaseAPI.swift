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

class ErrorResponse: Error {
    let customErrorMesage: String?
    
    init(errorMessage: String? = nil) {
        self.customErrorMesage = errorMessage
    }
}

class BaseAPI {
    
    private let session: URLSession
    private var jsonDecoder = JSONDecoder()
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    func execute<T>(
        request: URLRequest,
        sessionType: SessionType = .defaultSession,
        completion: @escaping ((Result<T, ErrorResponse>) -> Void)
    ) where T: Decodable {
        
        switch sessionType {
        case .defaultSession:
            session.dataTask(with: request) { (data, urlResponse, error) in
                self.handleResponse(data, urlResponse, error, completion: completion)
            }.resume()
        default:
            break
            //            self.handleResponse(ResourceManager.getMockDataForTileList(), nil, nil, completion: completion)
        }
    }
    
    func execute<T>(
        endpoint: String,
        httpMethod: HTTPMethod = .GET,
        sessionType: SessionType = .defaultSession,
        completion: @escaping ((Result<T, ErrorResponse>) -> Void)
    ) where T: Decodable {
        
        createRequest(from: endpoint, for: httpMethod) { [weak self] request in
            
            switch sessionType {
            case .defaultSession:
                self?.session.dataTask(with: request) { (data, urlResponse, error) in
                self?.handleResponse(data, urlResponse, error, completion: completion)
                }.resume()
            default:
                break
                //            self.handleResponse(ResourceManager.getMockDataForTileList(), nil, nil, completion: completion)
            }
        }
    }
    
    private func handleResponse<T: Decodable>(
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?,
        completion: @escaping (Result<T, ErrorResponse>) -> Void) {
            
            if error != nil {
                completion(.failure(ErrorResponse(errorMessage: error?.localizedDescription)))
            }
            
            if let data = data {
                do {
                    let decodedData = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch let error {
                    completion(.failure(ErrorResponse(errorMessage: error.localizedDescription)))
                }
            }
        }
    
    private func createRequest(
        from endpoint: String,
        for type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        AuthManager.shared.withValidToken { [weak self] token in
            guard let url = URL(string: endpoint) else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = type.rawValue
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            completion(request)
        }
        
    }
}
