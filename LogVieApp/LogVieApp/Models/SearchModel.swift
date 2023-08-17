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
    // nil 이 나오는 생성자 재정의
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decode(String.self, forKey:  .posterPath)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        backdropPath = (try? container.decodeIfPresent(String.self, forKey: .backdropPath)) ?? ""
    }
    
}
