//
//  ImageLoaderManager.swift
//  MVVM_example
//
//  Created by Marat on 01.02.2023.
//

import UIKit

class ImageCacheManager {
    
    func fetchImage(url: URL, completionHandler: @escaping(UIImage?) -> ()) {
        
        if let chaceImage = getCacheImage(url: url) {
            completionHandler(chaceImage)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let response = response , let data = data, let image = UIImage(data: data) {
                    completionHandler(image)
                    self.saveImageToCache(data: data, response: response)
                } else {
                    completionHandler(nil)
                }
            }.resume()
        }
    }
    
    private func saveImageToCache(data: Data, response: URLResponse) {
        guard let responseUrl = response.url else { return }
        let cacheResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cacheResponse, for: URLRequest(url: responseUrl))
    }
    
    private func getCacheImage(url: URL)-> UIImage? {
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cacheResponse.data)
        }
        return nil
    }
}
