//
//  UserService.swift
//  RickAndMortyApp
//
//  Created by Richard Pacheco on 10/05/24.
//

import Foundation

// MARK: - Service Protocol
protocol ServiceProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var parametersEncoding: ParametersEncoding { get }
}

extension ServiceProtocol {
    var headers: HTTPHeaders? {
        let headers: HTTPHeaders = [ 
            "Content-Type" : "application/json",
            "language" : Locale.current.language.languageCode?.identifier ?? "en"
        ]
        
        return headers
    }
}

// MARK: Protocol for the URLSessionProvider
protocol ProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (NetworkResponse<T>) -> Void) async where T: Decodable
    func cancel()
}

// MARK: Http methods that the API supports
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: Http task type for encoding
enum HTTPTask {
    case request
    case requestParameters( Parameters )
    case requestWithObject( Encodable )
}

// MARK: Encoding types for creating the URLRequest
enum ParametersEncoding {
    case url
    case json
}
