//
//  ViewController.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBlue
        table.delegate = self
        table.dataSource = self
        table.prefetchDataSource = self
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseID)
        
        return table
    }()

    var songsViewModel: SongsViewModelType
    
    init(viewModel: SongsViewModelType) {
        self.songsViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top-50"
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
        //self.songsViewModel.deleteAll()
        self.songsViewModel.getSongs()
    }

    private func setupUI() {
        self.view.backgroundColor = .systemMint
        self.view.addSubview(self.tableView)
        self.tableView.bindToSuperView(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        self.tableView.layer.cornerRadius = 20.0
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dc = DetailsViewController()
        dc.self.AlbumCover.image = UIImage(named: "missing")
        self.songsViewModel.imageData(index: indexPath.row) { data in
            if let data = data {
                DispatchQueue.main.async {
                    print("Data Returned for Image")
                    dc.AlbumCover.image = UIImage(data: data)
                }
            }
        }
        dc.AlbumName.text = self.songsViewModel.albumName(index: indexPath.row) ?? "Unknown"
        dc.ArtistName.text = self.songsViewModel.artistName(index: indexPath.row) ?? "Mysterious"
        dc.buttonStatus = self.songsViewModel.faveClicked(index: indexPath.row)
        dc.songsViewModel = self.songsViewModel as? SongsViewModel ?? SongsViewModel()
        dc.indexed = indexPath.row
        
        self.navigationController?.pushViewController(dc, animated: true)
        print("cell clicked")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50 // self.songsViewModel.count returns infinitely
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseID, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.AlbumName.text = self.songsViewModel.albumName(index: indexPath.row) ?? "Unknown"
        cell.ArtistName.text = self.songsViewModel.artistName(index: indexPath.row) ?? "Mysterious"
        
        cell.AlbumCover.image = UIImage(named: "missing")
        self.songsViewModel.imageData(index: indexPath.row) { data in
            if let data = data {
                DispatchQueue.main.async {
                    print("Data Returned for Image")
                    cell.AlbumCover.image = UIImage(data: data)
                }
            }
        }
        
        if (self.songsViewModel.faveClicked(index: indexPath.row) == 0){
            cell.FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
            
        else {
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
        
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.songsViewModel.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        self.songsViewModel.getSongs()
    }
}
