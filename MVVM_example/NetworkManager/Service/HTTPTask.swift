//
//  HTTPTask.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case request

    case requestParameters(bodyParametrs: Parameters?,
                           urlParametrs: Parameters?)

    case requestParametersAndHeader(bodyParametrs: Parameters?,
                                    urlParametrs: Parameters?,
                                    additionalHeader: HTTPHeaders?)
}
