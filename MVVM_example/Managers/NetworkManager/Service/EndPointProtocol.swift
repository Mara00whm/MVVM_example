//
//  EndPointProtocol.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

protocol EndPointProtocol {
    var baseURL: URL {get}
    var httpMethod: HTTPMethod {get}
    var task: HTTPTask {get}
    var header: HTTPHeaders? {get}
    var path: String {get}
}
