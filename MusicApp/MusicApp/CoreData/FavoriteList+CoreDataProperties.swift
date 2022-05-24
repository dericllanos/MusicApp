//
//  FavoriteList+CoreDataProperties.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 20/05/2022.
//
//

import Foundation
import CoreData


extension FavoriteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteList> {
        return NSFetchRequest<FavoriteList>(entityName: "FavoriteList")
    }
    
    @NSManaged public var albumName: String?
    @NSManaged public var artistName: String?
    @NSManaged public var favoriteStatus: Int32
    @NSManaged public var albumCoverUrl: String?

}

extension FavoriteList : Identifiable {

}
