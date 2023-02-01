//
//  AlbumsResponseDTO.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

struct PlayListDTO: Decodable {
     let albums: [PlayListModel]
}

struct PlayListModel: Decodable {
    let title, subtitle: String
    let image: String
}
