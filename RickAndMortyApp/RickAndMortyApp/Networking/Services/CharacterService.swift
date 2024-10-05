//
//  CharacterService.swift
//  RickAndMortyApp
//
//  Created by Richard Pacheco on 10/05/24.
//

import Foundation

// MARK: - Character service
enum CharacterService: ServiceProtocol {
    case getCharacters(page: Int)

    // MARK: - Path
    var path: String {
        let path = "/character"

        switch self {
        case .getCharacters:
            return NetworkConstants.serverURL + path
        }
    }

    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .getCharacters:
            return .get
        }
    }

    // MARK: - HTTPTask
    var task: HTTPTask {
        switch self {
        case .getCharacters(let page):
            return .requestParameters(["page": page])
        }
    }

    // MARK: - Parameters Encoding
    var parametersEncoding: ParametersEncoding {
        switch self {
        case .getCharacters:
            return .url
        }
    }
}
