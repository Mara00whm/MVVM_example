//
//  Endpoint.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

enum AlbumsEndpoint {
    case getListOfAlbums
}

// http://test.iospro.ru/playlistdata.json
extension AlbumsEndpoint: EndPointProtocol {
    var baseURL: URL {
        URL(string: EndpointConstants.baseURL)!
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        switch self {
        case .getListOfAlbums:
            return .request
        }
    }
    
    var header: HTTPHeaders? {
        nil
    }
    
    var path: String {
        EndpointConstants.albumsPath
    }
    
    
}
