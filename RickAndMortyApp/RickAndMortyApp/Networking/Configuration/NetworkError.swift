//
//  UserService.swift
//  RickAndMortyApp
//
//  Created by Richard Pacheco on 10/05/24.
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error {
    /// Server return a response, but its content is not valid
    case invalidResponse
    /// Server return a response, but its data is not valid
    case invalidData
    /// Server return an error
    case networkError
    /// Server return an empty response but was expected a JSON
    case noJSONData
    /// Error trying to decode server response to specific model
    case decodeError
    /// Generic error
    case unknown
}
