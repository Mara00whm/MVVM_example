//
//  NetworkRouter.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

typealias NetworkRouterCompletion = (_ data: Data?,
                                            _ response: URLResponse?,
                                            _ error: Error?) -> Void

protocol NetworkRouterProtocol: AnyObject {
    associatedtype EndPoint: EndPointProtocol

    func request(_ route: EndPoint, completionHandler : @escaping NetworkRouterCompletion)
    func request<T: Decodable>(endpoint: EndPoint, responseModel: T.Type) async -> Result<T, RequestError>

    func cancel()
}
