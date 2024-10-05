//
//  UserService.swift
//  RickAndMortyApp
//
//  Created by Richard Pacheco on 10/05/24.
//

import Foundation

// MARK: - Network Response
enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}
