//
//  Router.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

class Router<EndPoint: EndPointProtocol>: NetworkRouterProtocol {
    private var sessionTask: URLSessionTask?
    
    func request(_ route: EndPoint, completionHandler: @escaping NetworkRouterCompletion) {
        let task = URLSession.shared

        do {
            let request = try self.buildRequest(route: route)
            sessionTask = task.dataTask(with: request, completionHandler: { data, response, error in
                completionHandler(data, response, error)
            })
        } catch {
            completionHandler(nil, nil, error)
        }

        self.sessionTask?.resume()
    }

    func request<T: Decodable>(
        endpoint: EndPoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        do {
            let request = try self.buildRequest(route: endpoint)
    
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }


    func cancel() {
        self.sessionTask?.cancel()
    }

    private func buildRequest(route: EndPointProtocol) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)

        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {

            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            case .requestParameters(bodyParametrs: let bodyParametrs, urlParametrs: let urlParametrs):
                try  self.configureParameters(bodyParameters: bodyParametrs,
                                              urlParameters: urlParametrs,
                                              request: &request)

            case .requestParametersAndHeader(bodyParametrs: let bodyParametrs,
                                             urlParametrs: let urlParametrs,
                                             additionalHeader: let additionalHeader):
                self.addAddtinionalHeaders(additionalHeader, request: &request)
                try self.configureParameters(bodyParameters: bodyParametrs,
                                             urlParameters: urlParametrs,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request : inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, parameters: bodyParameters)
            }

            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, parameters: urlParameters)
            }
        } catch {
            throw error
        }
    }

    private func addAddtinionalHeaders(_ additionalHeader: HTTPHeaders?, request : inout URLRequest) {
        guard let additionalHeader = additionalHeader else {
            return
        }
        for (key, value) in additionalHeader {
            request.setValue(key, forHTTPHeaderField: value)
        }
    }

}
