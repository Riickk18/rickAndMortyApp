//
//  UserService.swift
//  RickAndMortyApp
//
//  Created by Richard Pacheco on 10/05/24.
//

import Foundation

extension URLComponents {

    init(service: ServiceProtocol) {
        
        let serverUrl: String = NetworkConstants.serverURL
        let url = URL(string: serverUrl + service.path)!

        #if DEBUG
        print("URL: " + url.absoluteString)
        print("HTTP Method: \(service.method)")
        #endif

        self.init(url: url, resolvingAgainstBaseURL: false)!
        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .url else { return }
        
        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
