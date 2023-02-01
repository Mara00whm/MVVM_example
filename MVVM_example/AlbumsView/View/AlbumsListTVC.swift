//
//  AlbumsListTVC.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import UIKit

class AlbumsListTVC: UITableViewController {
    
    var viewModel: AlbumsViewModelProtocol!
    
    private var alert: UIAlertController?
    
    private let searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.sizeToFit()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchController()
        viewModel.getListOfAlbums()
        tableViewSettings()
        createBindings()
    }
    
    private func createBindings() {
        viewModel.items.observe(on: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        
    }
    
    private func createAlertView(model: AlbumsViewModelData) {
        alert = UIAlertController(title: title, message: ViewTextConstants.enterText,
                                  preferredStyle: .alert)
        let title = model.title
        
        guard let alert = alert else {
            return
        }
        
        alert.addTextField { (textField) in
            textField.text = title
        }
        
        alert.addAction(UIAlertAction(title: ViewTextConstants.save,
                                      style: .default, handler: { [self, weak alert] (_) in
            let textField = alert?.textFields![0]
            guard let value = textField?.text else { return }
            viewModel.setNewValue(value, model: model)
        }))
        
        if self.searchController.isActive {
            self.searchController.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func createSearchController() {
        searchController.searchResultsUpdater = self
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    private func tableViewSettings() {
        tableView.register(AlbumsTVCell.self, forCellReuseIdentifier: AlbumsTVCell.reuseIdentifier)
        tableView.backgroundColor = .backgroundColor
    }
    //MARK: - Override funcs
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        ViewSizeConstants.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumsTVCell.reuseIdentifier,
                                                       for: indexPath) as? AlbumsTVCell else { return UITableViewCell() }
        let data = viewModel.items.value[indexPath.row]
        cell.setData(data)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ViewSizeConstants.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let index = indexPath.row
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil) { _ in
                let mapAction = UIAction(
                    title: ViewTextConstants.edit,
                    image: UIImage.editImage) { _ in
                        self.createAlertView(model: self.viewModel.items.value[index])
                    }
                let shareAction = UIAction(
                    title: ViewTextConstants.close,
                    image: UIImage.closeImage) { _ in
                        self.viewModel.deleteRow(self.viewModel.items.value[index])
                    }
                return UIMenu(title: "", image: nil, children: [mapAction, shareAction])
            }
    }
    
    private enum ViewTextConstants {
        static let close: String = "Hide"
        static let edit: String = "Edit"
        
        static let enterText: String = "Enter text"
        static let save: String = "Save"
    }
    
    private enum ViewSizeConstants {
        static let numberOfSections: Int = 1
        
        static let cellHeight: CGFloat = UIScreen.main.bounds.height/6
    }
    
}

extension AlbumsListTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchAtTableView(searchController.searchBar.text ?? "")
    }
}
