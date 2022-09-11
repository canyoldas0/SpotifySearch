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
    
    /// This execute only gets called from AuthService. It doesn't require Requestable object.
    /// Directly executes with the URLRequest.
    /// - parameters:
    ///     - request: URLRequest to be executed.
    ///     - sessionType: Session type to be defined whether as mock or default. Mock version can be implemented for improve testing setup.
    ///     - dispatchQueue: DispatchQueue that request will be executed in. Default main.
    ///     - completion: Generic Result completion.
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
    
    /// Response handler method.
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
                    } catch {
                        completion(.failure(NetworkError.decodingFailed))
                    }
                }
            }
        }
}
