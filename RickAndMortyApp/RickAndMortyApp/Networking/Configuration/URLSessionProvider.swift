//
//  UserService.swift
//  RickAndMortyApp
//
//  Created by Richard Pacheco on 10/05/24.
//

import Foundation

// MARK: - URLSessionProviderProgressDelegate
/// Protocol to monitor progress on requests
protocol URLSessionProviderProgressDelegate: AnyObject {
    func progress(value: Double)
}

// MARK: - URLSessionProvider
final class URLSessionProvider: ProviderProtocol {

    private var session: URLSessionProtocol
    private var task: URLSessionTask?
    private var observation: NSKeyValueObservation?
    weak var progressDelegate: URLSessionProviderProgressDelegate?

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    deinit {
        observation?.invalidate()
    }

    func request<T>(
        type: T.Type,
        service: ServiceProtocol,
        completion: @escaping (NetworkResponse<T>) -> Void
    ) async where T: Decodable {
        let request = await URLRequest(service: service)
        task = session.dataTask(request: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            self.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        }
        observation = task?.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            guard let self = self else {return}
            self.progressDelegate?.progress(value: progress.fractionCompleted)
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }

    private func handleDataResponse<T: Decodable>(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?,
        completion: (NetworkResponse<T>) -> Void
    ) {
        guard error == nil else {
            print(error as Any)
            return completion(.failure(.networkError))
        }
        
        guard let response = response else { return completion(.failure(.noJSONData)) }

        #if DEBUG
        print("[Service: \(response.url?.absoluteString ?? "")]")
        print("[StatusCode: \(response.statusCode)]")
        #endif

        switch response.statusCode {

        case NetworkConstants.successServerResponseRange:
            do {
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }

                let responseToPrint = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]

                #if DEBUG
                print("[Response: \(responseToPrint ?? ["": ""])]")
                #endif

                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                #if DEBUG
                print(error.localizedDescription, "ERROR:", error)
                #endif

                completion(.failure(.decodeError))
            }
        case NetworkConstants.failedServerResponseRange:
            processError(data: data, response: response, completion: completion)
        default:
            completion(.failure(.unknown))
        }
    }

    private func processError<T: Decodable>(
        data: Data?,
        response: HTTPURLResponse?,
        completion: (NetworkResponse<T>) -> Void
    ) {
        do {
            if let data = data, let jsonError = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                #if DEBUG
                print("Error: \(jsonError)")
                #endif

                completion(.failure(.networkError))
            }
        } catch {
            #if DEBUG
            if response?.statusCode == 404 {
                print("Status 404, page not found: \(response?.url?.absoluteString ?? "")")
            } else {
                print("Error parsing the json \(error.localizedDescription)")
            }
            #endif

            completion(.failure(.unknown))
        }
    }
}
