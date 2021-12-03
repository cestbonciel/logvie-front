//
//  RandomViewController.swift
//  LogVieApp
//
//  Created by a0000 on 2021/11/29.
//

import UIKit
import Alamofire

class RandomViewController: UIViewController {

    var movies:[Movie]?
    let posterBaseURL = "https://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var imgViewPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGetMovie: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnGetMovie.layer.cornerRadius = 10
        lblTitle.numberOfLines = 0
    }
    
    func getRandomMovie(page:Int){
        let endPoint = "https://api.themoviedb.org/3/movie/now_playing"
        let apiKey = "2b776cd7a06fe6316152d5c1ac2fecb1"
        
        let params:Parameters = ["api_key":apiKey, "language":"ko-KR", "page":page]
        
        let request = AF.request(endPoint, method: .get, parameters: params)
        request.responseDecodable(of: MovieInfo.self) { response in
            switch response.result{
            case.failure(let error):
                print(error.localizedDescription)
            case.success(let movieInfo):
                self.movies = movieInfo.results

                guard let movies = self.movies else {
                    return
                }
                let num = Int.random(in: 0..<20)
                let movie = movies[num]
                let title = movie.title
                let posterPath = movie.posterPath
                let posterFullPath = "\(self.posterBaseURL)\(posterPath)"

//                print("페이지 내 \(num+1) 번째 영화 : \(title)")

                self.lblTitle.text = title
                self.imgViewPoster.sd_setImage(with: URL(string: posterFullPath), completed: nil)
                
            }
        }
    }
    
    @IBAction func actGetMovie(_ sender: Any) {
        let num = Int.random(in: 1..<11)
//        print("\(num) 페이지 영화")
        getRandomMovie(page: num)
        
        UIView.transition(with: imgViewPoster, duration: 1.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        UIView.transition(with: lblTitle, duration: 1.7, options: .transitionCrossDissolve, animations: nil, completion: nil)
        
    }
    
    
    
    
}
