//
//  TableViewCell.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let reuseID = "\(TableViewCell.self)"
    var liked = false
    
    var buttonClickedAction : (() -> ())?
    var buttonStatus = 0
    
    lazy var AlbumCover: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 5.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    lazy var AlbumName: UILabel = {
        let aName = UILabel(frame: .zero)
        aName.translatesAutoresizingMaskIntoConstraints = false
        aName.font = .boldSystemFont(ofSize: 19)
        aName.numberOfLines = 1
        return aName
    }()
    
    lazy var ArtistName: UILabel = {
        let artist = UILabel(frame: .zero)
        artist.translatesAutoresizingMaskIntoConstraints = false
        artist.font = .systemFont(ofSize: 16)
        artist.numberOfLines = 1
        return artist
    }()
    
    lazy var FavoriteButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        if liked == false {
            btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.layer.cornerRadius = 5.0
        
        btn.addTarget(self, action: #selector(self.favorite), for: .touchUpInside)
        return btn
    }()
    
    var albumCover = UIImage()
    var albumName = ""
    var artistName = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    @objc
    private func favorite() {
        buttonClickedAction?()
        self.liked = !liked
        
        if liked == true {
            self.FavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            self.FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        print(liked)
    }
    
    private func setValues() {
        self.AlbumCover.image = albumCover
        self.AlbumName.text = albumName
        self.ArtistName.text = artistName
    }
    
    private func setupUI() {
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        
        vStack.addArrangedSubview(AlbumCover)
        vStack.addArrangedSubview(AlbumName)
        vStack.addArrangedSubview(ArtistName)
        
        self.AlbumCover.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.AlbumCover.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.FavoriteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.FavoriteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.contentView.addSubview(vStack)
        self.contentView.addSubview(FavoriteButton)
        
        self.AlbumCover.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -100).isActive = true
        
        self.FavoriteButton.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -97).isActive = true
        self.FavoriteButton.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -18).isActive = true
        
        self.AlbumName.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 100).isActive = true
        self.AlbumName.trailingAnchor.constraint(equalTo: FavoriteButton.safeAreaLayoutGuide.leadingAnchor, constant: -8).isActive = true
        
        self.ArtistName.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 100).isActive = true
        self.ArtistName.trailingAnchor.constraint(equalTo: FavoriteButton.safeAreaLayoutGuide.leadingAnchor, constant: -8).isActive = true
        self.ArtistName.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -14).isActive = true
        
        vStack.bindToSuperView(insets: UIEdgeInsets(top: 14, left: 8, bottom: 8, right: 8))
    }
    
    override func prepareForReuse() {
        self.AlbumCover.image = UIImage(named: "missing")
        self.AlbumName.text = "Unknown"
        self.ArtistName.text = "Someone Mysterious"
    }
}
