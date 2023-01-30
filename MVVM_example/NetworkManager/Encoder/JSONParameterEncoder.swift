//
//  JSONParameterEncoder.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoderProtocol {
    internal static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }

    }

}
