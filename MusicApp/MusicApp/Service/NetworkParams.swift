//
//  NetworkParams.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
// https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json

import Foundation

enum NetworkParams {
    case songsList
    case albumCover(path: String)
    
    var url: URL? {
        switch self {
        case .songsList:
            guard let urlComponents = URLComponents(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/albums.json") else { return nil }
            return urlComponents.url
            
        case .albumCover(path: let path):
            return URL(string: "\(path)")
        }
    }
}
