//
//  NetworkManager.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func getListOfAlbums()
}

class NetworkManager: NetworkManagerProtocol {
    private let networkRouter = Router<AlbumsEndpoint>()
    
    func getListOfAlbums() {
    }

}
