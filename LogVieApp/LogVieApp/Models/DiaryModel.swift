//
//  DiaryModel.swift
//  LogVieApp
//
//  Created by a0000 on 2021/11/29.
//

import Foundation

struct DiaryWriting: Codable{
    var count: Int
    var data:[Writings]
    
    struct Writings: Codable{
       var id:Int
       var userId:UUID
       var writingDate:String
       var movieTitle:String
       var diaryText:String
       var photo:String
       var mood:Int
       
        enum CodingKeys:String, CodingKey{
           case id,photo,mood
           case userId = "user_id"
           case movieTitle = "movie_title"
           case diaryText = "diary_text"
           case writingDate = "writing_date"
       }
   }
}


struct BackEndResponse: Codable{
    var result:String
    var data:DiaryWriting.Writings
}
