//
//  SongsViewModel.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
//

import Foundation

protocol SongsViewModelType {
    func bind(updateHandler: @escaping () -> Void)
    func getSongs()
    var count: Int { get }
    var getAllIndex: [Int] { get }
    func removeIndex (index: Int)
    func addIndex (index: Int)
    func imageData(index: Int, completion: @escaping (Data?) -> Void)
    func albumName(index: Int) -> String?
    func artistName(index: Int) -> String?
    func makeFavorited(index: Int)
    func deleteFavorite()
    func deleteAll()
    func loadFavorite()
    func getFavoriteInfo() -> String?
    func allAlbumNames() -> [String]
    func allArtistNames() -> [String]
    func allButtonStatus() -> [Int]
    func faveClicked(index: Int) -> Int
    func changeButtonStatus(index: Int)
    func removeFavorite(name: String)
}

class SongsViewModel: SongsViewModelType {
    
    private var coreDataManager: CoreDataManager
    
    var songs: [Album] {
        didSet {
            self.updateHandler?()
        }
    }
    
    private var favorited: FavoriteList? {
        didSet {
            self.updateHandler?()
        }
    }
    
    let dataFetcher: DataFetcher
    
    var updateHandler: (() -> Void)?
    
    init(songs: [Album] = [], coreDataManager: CoreDataManager = CoreDataManager(), dataFetcher: DataFetcher = NetworkManager()) {
        self.songs = songs
        self.coreDataManager = coreDataManager
        self.dataFetcher = dataFetcher
    }
    
    func bind(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }
    
    func getSongs() {
        self.dataFetcher.fetchModel(url: NetworkParams.songsList.url) { [weak self] (result: Result<Opening, Error>) in
            switch result {
            case .success(let page):
                let storedAlbums: [String] = self?.allAlbumNames() ?? []
                var data = page
                var cells: [Int] = []
                    
                if (storedAlbums.count >= 1) {
                    for index in 0...storedAlbums.count - 1 {
                        for count in 0...(page.feed.results.count) - 1 {
                            
                            data.feed.results[count].fav = 0
                            
                            if (storedAlbums[index] == data.feed.results[count].name) {
                                cells.append(count)
                            }
                        }
                    }
                }
                
                print(cells)
                DispatchQueue.main.sync {
                    self?.coreDataManager.removeAllIndices()
                    if (cells.count > 0){
                        for i in 0...cells.count - 1 {
                            self?.coreDataManager.addIndex(index: cells[i])
                            self?.coreDataManager.saveContext()
                        }
                    }
                }
                
                if (cells.count > 0){
                    for index in 0...cells.count - 1{
                        data.feed.results[cells[index]].fav = 1
                    }
                }
                
                self?.songs.append(contentsOf: data.feed.results)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var count: Int {
        return self.songs.count
    }
    
    var getAllIndex: [Int] {
        return self.coreDataManager.getAllIndex() ?? []
    }
    
    func removeIndex (index: Int) {
        self.coreDataManager.removeIndex(index: index)
        self.coreDataManager.saveContext()
    }
    
    func addIndex (index: Int) {
        self.coreDataManager.addIndex(index: index)
        self.coreDataManager.saveContext()
    }
    
    func imageData(index: Int, completion: @escaping (Data?) -> Void) {
        guard index < self.count else {
            completion(nil)
            return
        }
        
        guard let imagePath = self.songs[index].artworkUrl100 else {
            completion(nil)
            return
        }
        
        if let imageData = ImageCache.shared.getImageData(key: imagePath) {
            completion(imageData)
            return
        }
        
        self.dataFetcher.fetchData(url: NetworkParams.albumCover(path: imagePath).url) { result in
            switch result {
            case .success(let data):
                ImageCache.shared.setImageData(key: imagePath, data: data)
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func albumName(index: Int) -> String? {
        guard index < self.count else { return nil }
        return self.songs[index].name
    }
    
    func artistName(index: Int) -> String? {
        guard index < self.count else { return nil }
        return self.songs[index].artistName
    }
    
    func faveClicked(index: Int) -> Int {
        guard index < self.count else { return 0 }
        if (self.songs[index].fav == nil){
            self.songs[index].fav = 0
        }
        return self.songs[index].fav ?? 5
    }
    
    func changeButtonStatus(index: Int) {
        var x = 0
        if(self.songs[index].fav == 1 && x == 0) {
            self.songs[index].fav = 0
            x += 1
        }
        if(self.songs[index].fav == 0 && x == 0) {
            self.songs[index].fav = 1
        }
    }
    
    func makeFavorited(index: Int) {
        let favAlbum = self.songs[index]
        self.favorited = self.coreDataManager.makeFavorite(favAlbum: favAlbum)
        print ("adding " + favAlbum.artistName)
        self.coreDataManager.saveContext()
    }
    
    func deleteFavorite() {
        if let favorited = favorited {
            self.coreDataManager.deleteFavorite(favorited)
        }
        self.favorited = nil
    }
    
    func deleteAll() {
        self.coreDataManager.deleteAll()
    }
    
    func loadFavorite() {
        self.favorited = self.coreDataManager.fetchFavorite()
    }
    
    func getFavoriteInfo() -> String? {
        guard let name = self.favorited?.albumName  else { return nil }
        let displayText = "\(name)"
        return displayText
    }
    
    func allAlbumNames() -> [String]{
        self.coreDataManager.allAlbumNames()
    }
    
    func allArtistNames() -> [String]{
        self.coreDataManager.allArtistNames()
    }
    
    func allButtonStatus() -> [Int]{
        self.coreDataManager.allButtonStatus()
    }
    
    func removeFavorite(name: String){
        self.coreDataManager.removeFavorite(name: name)
    }
}

