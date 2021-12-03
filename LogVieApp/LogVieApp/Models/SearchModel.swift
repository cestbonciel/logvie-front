//
//  SearchModel.swift
//  LogVieApp
//
//  Created by today0818 on 2021/11/28.
//

import Foundation

struct MovieInfo:Codable {
    var page:Int
    var results:[Movie]
    
}

struct Movie:Codable {
    var backdropPath:String
    var id:Int
    var originalTitle:String
    var overview:String
    var posterPath:String
    var releaseDate:String
    var title:String
    var voteAverage:Double
    
    enum CodingKeys:String, CodingKey{
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
