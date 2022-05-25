//
//  DetailsViewController.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var buttonStatus = 0
    var indexed = 0
    var songsViewModel = SongsViewModel()
    
    lazy var AlbumCover: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 5.0
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        return imageView
    }()
    
    lazy var AlbumName: UILabel = {
        let aName = UILabel(frame: .zero)
        aName.translatesAutoresizingMaskIntoConstraints = false
        aName.textAlignment = .justified
        aName.font = .boldSystemFont(ofSize: 24)
        aName.numberOfLines = 0
        return aName
    }()
    
    lazy var ArtistName: UILabel = {
        let artist = UILabel(frame: .zero)
        artist.translatesAutoresizingMaskIntoConstraints = false
        artist.textAlignment = .justified
        artist.font = .systemFont(ofSize: 19)
        artist.numberOfLines = 0
        return artist
    }()
    
    lazy var FavoriteButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        if buttonStatus == 0 {
            btn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else {
            btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.layer.cornerRadius = 5.0
        
        btn.addTarget(self, action: #selector(self.favorite), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setBtnValue()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        self.setBtnValue()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
        self.setBtnValue()
    }
    
    @objc
    private func favorite() {
        if (buttonStatus == 0){
            self.FavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            buttonStatus = 1
            self.songsViewModel.changeButtonStatus(index: indexed)
            self.songsViewModel.makeFavorited(index: indexed)
            self.songsViewModel.addIndex(index: indexed)
        }
        else {
            self.FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            buttonStatus = 0
            self.songsViewModel.changeButtonStatus(index: indexed)
            self.songsViewModel.removeFavorite(name: self.ArtistName.text ?? "Unknown")
            self.songsViewModel.removeIndex(index: indexed)
        }
        print(self.songsViewModel.getAllIndex)
    }
    
    private func setBtnValue() {
        if buttonStatus == 0 {
            self.FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else {
            self.FavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    private func setupUI() {
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        
        vStack.addArrangedSubview(AlbumCover)
        vStack.addArrangedSubview(AlbumName)
        vStack.addArrangedSubview(ArtistName)
        
        self.AlbumCover.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.AlbumCover.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.AlbumName.frame.size.width = 200
        
        self.FavoriteButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        self.FavoriteButton.widthAnchor.constraint(equalToConstant: 62).isActive = true
        
        self.view.addSubview(vStack)
        self.view.addSubview(FavoriteButton)
        
        self.AlbumCover.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.AlbumCover.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        
        self.FavoriteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.FavoriteButton.topAnchor.constraint(equalTo: self.ArtistName.safeAreaLayoutGuide.bottomAnchor, constant: 9).isActive = true
    }
}
