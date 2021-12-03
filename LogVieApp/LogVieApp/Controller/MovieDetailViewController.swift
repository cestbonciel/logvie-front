//
//  MovieDetailViewController.swift
//  LogVieApp
//
//  Created by today0818 on 2021/11/29.
//

import UIKit
import Alamofire
import SDWebImage

class MovieDetailViewController: UIViewController {

    var movie:Movie?
    var movies:[Movie]?
    
    let posterBaseURL = "https://image.tmdb.org/t/p/w500"
    let apiKey = "2b776cd7a06fe6316152d5c1ac2fecb1"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOriginalTitle: UILabel!
    @IBOutlet weak var lblReleaseYear: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgBackdrop: UIImageView!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customButton()
        movieDetail()
    }
    
    func customButton(){
        btnBookmark.backgroundColor = UIColor(red: 139/255, green: 97/255, blue: 53/255, alpha: 1)
        btnBookmark.layer.cornerRadius = 10
        btnBookmark.layer.shadowColor = UIColor.gray.cgColor
        btnBookmark.layer.shadowOpacity = 0.2
        btnBookmark.layer.shadowOffset = CGSize.zero
        btnBookmark.layer.shadowRadius = 2
    }
    
    @IBAction func actFavorite(_ sender: Any) {
        guard let movie = movie else {
            return
        }
        let movieId = movie.id
        
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {return}
        
        post(movieId: movieId, userId: uid)
    }

    func post(movieId:Int, userId:String){
        let strURL = "http://localhost:8000/logvie_app/favorites/"
        let params:Parameters = ["movie_id":movieId, "user_id":userId]
        let request = AF.request(strURL, method: .post, parameters: params)
        request.responseDecodable(of: PostFavorites.self) { response in
            switch response.result{
            case.failure(let error):
                print(error.errorDescription)
            case.success(let postFavorites):
                let result = postFavorites.result as? String
                if result == "sucess" {
                    print("성공")
                } else {
                    print("실패")
                }
            }
        }

    }
    
    func movieDetail(){
        guard let movie = movie,
              let koreanTitle = movie.title as? String,
              let originalTitle = movie.originalTitle as? String,
              let releaseDate = movie.releaseDate as? String,
              let voteAverage = movie.voteAverage as? Double,
              let poster = movie.posterPath as? String,
              let backdrop = movie.backdropPath as? String,
              let overview = movie.overview as? String else {
                  return
              }
        lblTitle.text = koreanTitle
        lblOriginalTitle.text = originalTitle
        lblReleaseYear.text = "\(releaseDate.prefix(4))"
        lblRating.text = "\(voteAverage)"
        
        let posterPath = movie.posterPath
        let posterFullPath = "\(posterBaseURL)\(posterPath)"
        imgPoster.sd_setImage(with: URL(string: posterFullPath), completed: nil)
        
        let backdropPath = movie.backdropPath
        let backdropFullPath = "\(posterBaseURL)\(backdropPath)"
        imgBackdrop.sd_setImage(with: URL(string: backdropFullPath), completed: nil)
        lblOverview.text = overview
        lblOverview.numberOfLines = 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
