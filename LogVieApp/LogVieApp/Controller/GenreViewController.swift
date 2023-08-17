//
//  GenreViewController.swift
//  LogVieApp
//
//  Created by today0818 on 2021/11/28.
//

import UIKit
import SDWebImage
import Alamofire

class GenreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblGenre: UILabel!
    
    var genre:String?
    var genreId:Int?
    
    var movies:[Movie]?
    
    let posterBaseURL = "https://image.tmdb.org/t/p/w500"
    let apiKey = "2b776cd7a06fe6316152d5c1ac2fecb1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let genre = genre {
            lblGenre.text = "\(genre) 장르 인기 영화"
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let genreId = genreId {
            getMovies(genre: genreId)
        }
//        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 139.0/255.0, green: 97.0/255.0, blue: 53.0, alpha: 1.0)
    }
    
    
    func getMovies(genre:Int){
        let EndPoint = "https://api.themoviedb.org/3/discover/movie"
        let params:Parameters = ["api_key":apiKey, "language":"ko-KR","with_genres":genre]
        
        let request = AF.request(EndPoint, method: .get, parameters: params)
        request.responseDecodable(of: MovieInfo.self) { response in
            switch response.result{
            case .failure(let error):
                print(error.errorDescription)
            case.success(let movieInfo):
                self.movies = movieInfo.results
    
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        
        cell.backgroundColor = UIColor(red: 234, green: 232, blue: 230, alpha: 1)
        cell.layer.cornerRadius = 10
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.1
        cell.layer.masksToBounds = false
        
        guard let movies = self.movies else {
            return cell
        }
        
        let movie = movies[indexPath.row]

        let posterPath = movie.posterPath
        let posterFullPath = "\(posterBaseURL)\(posterPath)"
        if let imageViewPoster = cell.viewWithTag(1) as? UIImageView{
            imageViewPoster.sd_setImage(with: URL(string: posterFullPath), completed: nil)
        }
        
        let title = movie.title
        let lblTitle = cell.viewWithTag(2) as? UILabel
        lblTitle?.text = title
        lblTitle?.numberOfLines = 0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3 - 3
        let size = CGSize(width: width, height: width*1.5)
        return size
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? MovieDetailViewController,
           let indexPaths = collectionView.indexPathsForSelectedItems,
           let movies = self.movies{
            if let indexPath = indexPaths.first{
                destVC.movie = movies[indexPath.row]
            }
        }
    }
    

}
