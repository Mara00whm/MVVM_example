//
//  AlbumsViewModel.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import Foundation

protocol AlbumsViewModelProtocol {
    var items: Observable<[AlbumsViewModelData]> { get }
    
    func getListOfAlbums()
    func searchAtTableView(_ text: String)
    func setNewValue(_ text: String, model: AlbumsViewModelData)
    func deleteRow(_ model: AlbumsViewModelData)
}

class AlbumsViewModel: AlbumsViewModelProtocol {
    
    private let networkManager: NetworkManagerProtocol

    private var listOfAlbums: [AlbumsViewModelData] = [] {
        didSet {
            self.items.value = listOfAlbums
            self.saveToCache()
        }
    }
    
    var items: Observable<[AlbumsViewModelData]> = Observable([])
    
    init(networkManager: NetworkManagerProtocol = NetworkManager() ) {
        self.networkManager = networkManager
    }
    
    func getListOfAlbums() {
        Task {
            let result = await networkManager.getListOfAlbums()
            switch result {
            case .success(let value):
                listOfAlbums = value.albums.map(AlbumsViewModelData.init)
            case .failure(let error):
                print(error.localizedDescription)
                // обработка ошибок при небоходимости
            }
        }
    }
    
    //MARK: - Work with model cache
    //В тз не было указано что именно нужно делать с кэшэм данных. С помощью этих методов можно сохранять и получать данные
    func saveToCache() {
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let disk = DiskStorage(path: path)
        let storage = CodableStorage(storage: disk)
    
        do {
            try storage.save(listOfAlbums, for: StringConstants.cachePath)
        } catch {
            print(error.localizedDescription)
            // обработка ошибок при небоходимости
        }
    }

    func getCachedModel() {
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let disk = DiskStorage(path: path)
        let storage = CodableStorage(storage: disk)

        do {
            let cached: [AlbumsViewModelData] = try storage.fetch(for: StringConstants.cachePath)
        } catch {
            print(error.localizedDescription)
            // обработка ошибок при небоходимости
        }
    }
    
    //MARK: - Search text
    func searchAtTableView(_ text: String) {
        
        if text.isEmpty {
            items.value = listOfAlbums
        } else {
            items.value = listOfAlbums.filter {
                $0.title.lowercased().contains(text.lowercased()) || $0.subtitle.lowercased().contains(text.lowercased())
            }
        }
    }
    
    func setNewValue(_ text: String, model: AlbumsViewModelData) {
        //we can get unexpected result if search smth in textFiled
        //this method for find element index
        for i in 0..<listOfAlbums.count {
            if listOfAlbums[i] == model {
                listOfAlbums[i].title = text
                return
            }
        }
    }
    
    func deleteRow(_ model: AlbumsViewModelData) {
        for i in 0..<listOfAlbums.count {
            if listOfAlbums[i] == model {
                listOfAlbums.remove(at: i)
                return
            }
        }
    }
    
    private enum StringConstants {
        static let cachePath: String = "BestAppInTheWorld"
    }
    
}
