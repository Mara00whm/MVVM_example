//
//  AlbumsTVCell.swift
//  MVVM_example
//
//  Created by Marat on 31.01.2023.
//

import UIKit

class AlbumsTVCell: UITableViewCell {
    // Reuse ID
    static let reuseIdentifier = String(describing: AlbumsTVCell.self)

    //MARK: - Views
    private let activityIndicator = UIActivityIndicatorView()
    
    private let posterImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let albumTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .titleForegroundColor
        view.text = "title"
        return view
    }()
    
    private let albumSubtitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "subtitle"
        view.textColor = .subtitleForegroundColor
        return view
    }()
    
    private let stackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    //MARK: - Override funcs
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createAnchors()
        contentView.backgroundColor = .backgroundColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
    }
    
    //MARK: - Settings
    
    func setData(_ data: AlbumsViewModelData) {
        self.albumTitle.text = data.title
        self.albumSubtitle.text = data.subtitle
        
        self.configureActivityView()
        if let url = URL(string: data.imagePath) {
            ImageCacheManager().fetchImage(url: url) { image in
                DispatchQueue.main.async {
                    if let image = image {
                        self.posterImage.image = image
                    } else {
                        self.posterImage.image = UIImage.defaultAlbumImage
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func createAnchors() {
        contentView.addSubview(posterImage)
        NSLayoutConstraint.activate([
            posterImage.widthAnchor.constraint(equalTo: posterImage.heightAnchor),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor,
                                             constant: ViewSizeConstants.imageTopPadding),
            posterImage.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                              constant: ViewSizeConstants.imageLeftPadding),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: ViewSizeConstants.imageBotPadding),
        ])
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(albumTitle)
        stackView.addArrangedSubview(albumSubtitle)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: posterImage.rightAnchor,
                                            constant: ViewSizeConstants.stackViewLeftPadding),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.centerYAnchor.constraint(equalTo: posterImage.centerYAnchor)
        ])
    }
    
    private func configureActivityView() {
        activityIndicator.color = .darkGray

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: posterImage.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: posterImage.centerYAnchor).isActive = true
        
        activityIndicator.startAnimating()
    }
    
    private enum ViewSizeConstants {
        static let stackViewLeftPadding: CGFloat = 15
        
        static let imageTopPadding: CGFloat = 5
        static let imageLeftPadding: CGFloat = 5
        static let imageBotPadding: CGFloat = -5
    }
    
}
