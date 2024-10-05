//
//  UserService.swift
//  RickAndMortyApp
//
//  Created by Richard Pacheco on 10/05/24.
//

import Foundation

// MARK: - URLRequest extension
extension URLRequest {

    // MARK: - Initializer
    init(service: ServiceProtocol) async {
        let urlComponents = URLComponents(service: service)
        
        self.init(url: urlComponents.url!)
        
        httpMethod = service.method.rawValue

        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }

        guard case let .requestWithObject(entity) = service.task, service.parametersEncoding == .json else { return }
        do {
            httpBody = try entity.toJSONData()
            #if DEBUG
            print("BODY: \n\(String(data: httpBody ?? Data(), encoding: .utf8) as Any)")
            #endif
        } catch {
            #if DEBUG
            print("Encoding error", error.localizedDescription)
            #endif
        }
    }
    
}

extension Encodable {
    func toJSONData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}
