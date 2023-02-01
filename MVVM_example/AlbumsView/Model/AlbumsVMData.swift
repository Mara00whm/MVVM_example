//
//  AlbumsViewModel.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

struct AlbumsViewModelData: Codable, Equatable {
    var title, subtitle: String
    let imagePath: String
}

extension AlbumsViewModelData {
    init(album: PlayListModel) {
        self.title = album.title
        self.subtitle = album.subtitle
        self.imagePath = album.image
    }
}
