//
//  ImageExtension.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation
import UIKit

extension UIImage {
    static var defaultAlbumImage: UIImage {
        UIImage(systemName: "play")!
    }
    
    static var closeImage: UIImage {
        UIImage(systemName: "clear")!
    }
    
    static var editImage: UIImage {
        UIImage(systemName: "pencil")!
    }
}
