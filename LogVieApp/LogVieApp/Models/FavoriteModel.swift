//
//  FavoriteModel.swift
//  LogVieApp
//
//  Created by today0818 on 2021/12/01.
//

import Foundation

struct GetFavorites: Codable{
    var count: Int
    var data:[Favorite]
    
    struct Favorite: Codable{
        var id:Int
        var movieId:Int
        var userId:String
        var pickDate:String
        
        enum CodingKeys:String, CodingKey{
            case id
            case movieId = "movie_id"
            case userId = "user_id"
            case pickDate = "pick_date"
            
        }
    }
}


struct PostFavorites:Codable{
    var result: Int
    var data:Favorite
    
    struct Favorite:Codable{
        var id:Int
        var movieId:Int
        var userId:String
        var pickDate:String
        
        enum CodingKeys:String, CodingKey{
            case id
            case movieId = "movie_id"
            case userId = "user_id"
            case pickDate = "pick_date"
            
        }
    }
}
