//
//  SongModel.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
//

import Foundation

struct Opening: Decodable {
    var feed: Feed
}

struct Feed: Decodable {
    var results: [Album]
}

// MARK: - Results
struct Album: Decodable {
    let artistName, id, name, releaseDate: String
    let artistID: String?
    let artistURL: String?
    let artworkUrl100: String?
    let genres: [Genre]?
    let url: String
    var fav: Int?

    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate
        case artistID = "artistId"
        case artistURL = "artistUrl"
        case artworkUrl100, genres, url, fav
    }
}

// MARK: - Genre
struct Genre: Decodable {
    let genreID: String
    let name: Name
    let url: String

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}

enum Name: String, Decodable {
    case alternative = "Alternative"
    case childrenSMusic = "Children's Music"
    case classical = "Classical"
    case country = "Country"
    case dance = "Dance"
    case electronic = "Electronic"
    case hipHopRap = "Hip-Hop/Rap"
    case latin = "Latin"
    case music = "Music"
    case pop = "Pop"
    case rBSoul = "R&B/Soul"
    case rock = "Rock"
    case soundtrack = "Soundtrack"
}
