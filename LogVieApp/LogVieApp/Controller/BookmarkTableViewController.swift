//
//  BookmarkTableViewController.swift
//  LogVieApp
//
//  Created by today0818 on 2021/11/28.
//

import UIKit
import Alamofire
import SDWebImage

class BookmarkTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies:[Movie] = []
    var favoritesCount:Int = 0
    
    let posterBaseURL = "https://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 100
        
        get()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        get()
        tableView.reloadData()
    }
    
    
    func get(){
        let strURL = "http://localhost:8000/logvie_app/favorites/"
        let request = AF.request(strURL, method: .get)
        request.responseDecodable(of: GetFavorites.self) { response in
            switch response.result{
            case.failure(let error):
                print(error.errorDescription)
            case.success(let getFavorites):
                let favorites = getFavorites.data
                self.favoritesCount = favorites.count
                for favorite in favorites{
                    let movieId = favorite.movieId
                    self.getMovieDetail(movieId: movieId)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getMovieDetail(movieId:Int){
        let endPoint:String = "https://api.themoviedb.org/3/movie/\(movieId)"
        let apiKey = "2b776cd7a06fe6316152d5c1ac2fecb1"
        
        let params:Parameters=["api_key":apiKey, "language":"ko-KR"]
        let request = AF.request(endPoint, method: .get, parameters: params)
        request.responseDecodable(of: Movie.self) { response in
            switch response.result{
            case.failure(let error):
                print(error.errorDescription)
            case.success(let movie):
                self.movies.append(movie)
                
                if self.movies.count >= self.favoritesCount{
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellB", for: indexPath)
    
        let movie = self.movies[indexPath.row]
        let movieId = movie.id
        
        let title = movie.title
        let posterPath = movie.posterPath
        let posterFullPath = "\(posterBaseURL)\(posterPath)"
        
        if let lblTitle = cell.viewWithTag(4) as? UILabel{
            lblTitle.text = "\(title)"
        }
        
        if let imgView = cell.viewWithTag(3) as? UIImageView{
            imgView.sd_setImage(with: URL(string: posterFullPath), completed: nil)
        }
        
        return cell
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
