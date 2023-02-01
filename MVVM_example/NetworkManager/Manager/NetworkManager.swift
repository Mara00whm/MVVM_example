//
//  NetworkManager.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func getListOfAlbums() async -> Result<PlayListDTO, RequestError>
}

class NetworkManager: NetworkManagerProtocol {
    private let networkRouter = Router<AlbumsEndpoint>()
    
    func getListOfAlbums() async -> Result<PlayListDTO, RequestError> {
        await networkRouter.request(endpoint: .getListOfAlbums, responseModel: PlayListDTO.self)
    }

}
