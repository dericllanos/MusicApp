//
//  FavoriteIndex+CoreDataProperties.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 24/05/2022.
//
//

import Foundation
import CoreData


extension FavoriteIndex {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteIndex> {
        return NSFetchRequest<FavoriteIndex>(entityName: "FavoriteIndex")
    }

    @NSManaged public var index: Int32

}

extension FavoriteIndex : Identifiable {

}
