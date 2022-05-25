//
//  FavoritesViewController.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var albumNames : [String] = []
    var artistNames : [String] = []
    var favorites : [Int] = []
    var buttonStatus: [Int] = []
    var songsViewModel = SongsViewModel()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBlue
        table.delegate = self
        table.dataSource = self
        table.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.reuseID)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        self.setupUI()
        self.initializeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.initializeData()
    }
    
    private func initializeData() {
        self.songsViewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        self.songsViewModel.getSongs()
        self.albumNames = self.songsViewModel.allAlbumNames()
        self.artistNames = self.songsViewModel.allArtistNames()
        self.buttonStatus = self.songsViewModel.allButtonStatus()
        self.favorites = self.songsViewModel.getAllIndex
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemMint
        self.view.addSubview(self.tableView)
        self.tableView.bindToSuperView(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        self.tableView.layer.cornerRadius = 20.0
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dc = DetailsViewController()
        
        dc.self.AlbumName.text = self.songsViewModel.albumName(index: self.songsViewModel.getAllIndex[indexPath.row])
        dc.self.ArtistName.text = self.songsViewModel.artistName(index: self.songsViewModel.getAllIndex[indexPath.row])
        dc.self.buttonStatus = self.songsViewModel.faveClicked(index: self.songsViewModel.getAllIndex[indexPath.row])
        
        dc.self.AlbumCover.image = UIImage(named: "missing")
        self.songsViewModel.imageData(index: self.songsViewModel.getAllIndex[indexPath.row]) { data in
            if let data = data {
                DispatchQueue.main.async {
                    dc.AlbumCover.image = UIImage(data: data)
                }
            }
        }
        
        dc.songsViewModel = self.songsViewModel as SongsViewModel
        dc.indexed = indexPath.row
        self.navigationController?.pushViewController(dc, animated: true)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.reuseID, for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell() }
        
        cell.AlbumName.text = self.albumNames[indexPath.row]
        cell.ArtistName.text = self.artistNames[indexPath.row]
        
        if (self.songsViewModel.faveClicked(index: indexPath.row) == 0){
            cell.FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
            
        if (self.songsViewModel.faveClicked(index: indexPath.row) == 1) {
            cell.FavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        cell.buttonClickedAction = { [] in
            var hasChanged = 0
            if (self.songsViewModel.faveClicked(index: indexPath.row) == 0){
                cell.FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.songsViewModel.changeButtonStatus(index: indexPath.row)
                hasChanged += 1
                self.songsViewModel.makeFavorited(index: indexPath.row)
                self.songsViewModel.addIndex(index: indexPath.row)
            }
            if (self.songsViewModel.faveClicked(index: indexPath.row) == 1 && hasChanged == 0) {
                cell.FavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.songsViewModel.changeButtonStatus(index: indexPath.row)
                self.songsViewModel.removeFavorite(name: self.songsViewModel.artistName(index: indexPath.row) ?? "")
                self.songsViewModel.removeIndex(index: indexPath.row)
            }
            print("reload")
            self.tableView.reloadData()
        }

        cell.AlbumCover.image = UIImage(named: "missing")
        self.songsViewModel.imageData(index: self.songsViewModel.getAllIndex[indexPath.row]) { data in
            if let data = data {
                DispatchQueue.main.async {
                    cell.AlbumCover.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.songsViewModel.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        self.songsViewModel.getSongs()
    }
}
