//
//  ParameterEncoder.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoderProtocol {
    static func encode(urlRequest : inout URLRequest, parameters: Parameters) throws
}
