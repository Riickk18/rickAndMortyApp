//
//  UserService.swift
//  RickAndMortyApp
//
//  Created by Richard Pacheco on 10/05/24.
//

import Foundation

// MARK: - Network Constants
enum NetworkConstants {
    static let serverURL = "https://rickandmortyapi.com/api"
    static let successServerResponseRange: ClosedRange<Int> = 200...299
    static let failedServerResponseRange: ClosedRange<Int> = 400...599
}

// MARK: - Typealias
typealias Parameters = [String: Any]
typealias HTTPHeaders = [String:String]
