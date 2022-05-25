//
//  CoreDataManager.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 24/05/2022.
//

import CoreData
import UIKit

class CoreDataManager {
    
    // MARK: CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MusicApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Something went wrong, \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error Saving: \(error)")
            }
        }
    }
    
    func makeFavorite(favAlbum: Album) -> FavoriteList? {
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteList", in: context) else { return nil }
        let favorited = FavoriteList(entity: entity, insertInto: context)
        favorited.albumName = favAlbum.name
        favorited.artistName = favAlbum.artistName
        favorited.favoriteStatus = Int32(favAlbum.fav ?? 0)
        favorited.albumCoverUrl = favAlbum.artworkUrl100
        
        return favorited
    }
    
    func deleteFavorite(_ favorited: FavoriteList) {
        let context = self.persistentContainer.viewContext
        context.delete(favorited)
        self.saveContext()
    }
    
    func deleteAll(){
       let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteList")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                do
                {
                    try context.execute(deleteRequest)
                    try context.save()
                } catch {
                    print ("There was an error")
                }
    }
    
    func allAlbumNames() -> [String] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
          do {
            // Peform Fetch Request
            let albums = try context.fetch(request)
              return albums.map({$0.albumName ?? "empty"})
          } catch {
            print("Unable to Fetch  (\(error))")
          }
          return []
    }
    
    func allArtistNames() -> [String] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        
        do {
            let albums = try context.fetch(request)
            return albums.map({$0.artistName ?? "empty"})
        } catch {
            print("Unable to Fetch (\(error))")
        }
        return []
    }
    
    func allButtonStatus() -> [Int] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        
        do {
        let albums = try context.fetch(request)
            return albums.map({Int($0.favoriteStatus)})
        } catch {
            print("Unable to Fetch Saved Albums, (\(error))")
        }
        return []
    }
    
    func fetchFavorite() -> FavoriteList? {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let favorited = results.first {
                return favorited
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func getFavoriteCount() -> Int? {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        
        do {
          let albums = try context.fetch(request)
            return albums.map({Int32($0.favoriteStatus)}).count
        } catch {
          print("Unable to Fetch Saved Albums, (\(error))")
        }
        return 0
    }
    
    func removeFavorite(name: String) {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            for index in 0...results.count - 1 {
                if name == (results[index].artistName ?? "") {
                    let favorited = results[index]
                    print ("deleting... " + (favorited.artistName ?? "nothing"))
                    context.delete(favorited)
                    self.saveContext()
                }
            }
        } catch {
            print(error)
        }
    }
    
    func removeAllIndices() {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteIndex")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func removeIndex(index: Int) {
        let context = self.persistentContainer.viewContext

        let request: NSFetchRequest<FavoriteIndex> = FavoriteIndex.fetchRequest()

        do {
            let results = try context.fetch(request)
            for count in 0...results.count - 1 {
                if (index == results[count].index) {
                    let favorited = results[count]
                    context.delete(favorited)
                    self.saveContext()
                }
            }
        } catch {
            print(error)
        }
    }

    func addIndex(index: Int) -> FavoriteIndex? {
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteIndex", in: context) else { return nil }
        let favorited = FavoriteIndex(entity: entity, insertInto: context)
        favorited.index = Int32(index)
        return favorited
    }

    func getAllIndex() -> [Int]? {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<FavoriteIndex> = FavoriteIndex.fetchRequest()
        do {
            let indices = try context.fetch(request)
            return indices.map({Int($0.index)})
        } catch {
            print("Unable to Fetch (\(error))")
        }
        return []
    }
}
