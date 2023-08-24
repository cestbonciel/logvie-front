//
//  SearchViewController.swift
//  LogVieApp
//
//  Created by today0818 on 2021/11/28.
//

import UIKit
import Alamofire
import SDWebImage

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
  
    let genres = ["#공포", "#코믹", "#로맨스", "#애니메이션" ,"#SF/액션", "#드라마"]
    let genreIds = [27, 35, 10749, 16, 878, 18]
    var colors = [
        UIColor(red: 84/255.0, green: 106/255.0, blue: 127/255.0, alpha: 1),
        UIColor(red: 96/255.0, green: 132/255.0, blue: 171/255.0, alpha: 1),
        UIColor(red: 126/255.0, green: 188/255.0, blue: 181/255.0, alpha: 1),
        UIColor(red: 240/255.0, green: 220/255.0, blue: 140/255.0, alpha: 1),
        UIColor(red: 223/255.0, green: 129/255.0, blue: 108/255.0, alpha: 1),
        UIColor(red: 234/255.0, green: 170/255.0, blue: 89/255.0, alpha: 1)
        ]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies:[Movie]?
    
    let posterBaseURL = "https://image.tmdb.org/t/p/w500"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
        customSearchBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 70
        tableView.frame = CGRect(x: 0, y: 140, width: view.frame.width, height: 762)
        tableView.alpha = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    
    func customSearchBar(){
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "영화 제목을 입력하세요"
        
        searchBar.setImage(UIImage(named: "search"), for: UISearchBar.Icon.search, state: .normal)
        searchBar.setImage(UIImage(named: "clear"), for: .clear, state: .normal)
        searchBar.showsCancelButton = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let q = searchBar.text {
            search(query:q)
            searchBar.resignFirstResponder()
        }
        tableView.alpha = 1
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.alpha = 0
        searchBar.resignFirstResponder()
    }
    
    func search(query:String){
        let endPoint = "https://api.themoviedb.org/3/search/movie"
		let apiKey = Bundle.main.apiKey
        
        let params:Parameters=["api_key":apiKey,"query":query, "language":"ko-KR", "page":1]
        let request = AF.request(endPoint, method: .get, parameters: params)
        request.responseDecodable(of: MovieInfo.self) { response in
            switch response.result{
            case.failure(let error):
                print(error)
            case.success(let movieInfo):
                self.movies = movieInfo.results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as UICollectionViewCell
        cell.backgroundColor = colors[indexPath.row]
        cell.layer.cornerRadius = 20
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.1
        cell.layer.masksToBounds = false
        
        let lblGenre = cell.viewWithTag(1) as? UILabel
        lblGenre?.text = genres[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2 - 3
        let size = CGSize(width: width, height: width)
        
        return size
    }
      
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        guard let movies = self.movies else {
            return cell
        }
        
        let movie = movies[indexPath.row]
        
        if let lblTitle = cell.viewWithTag(3) as? UILabel{
            lblTitle.text = movie.title
        }
        
        let posterPath = movie.posterPath
        let posterFullPath = "\(posterBaseURL)\(posterPath)"
        if let imageViewPoster = cell.viewWithTag(2) as? UIImageView{
            imageViewPoster.sd_setImage(with: URL(string: posterFullPath), completed: nil)
        }
        return cell

    }
        
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search"{
            if let destVC1 = segue.destination as? MovieDetailViewController,
               let indexPath = tableView.indexPathForSelectedRow,
               let movies = self.movies {
                destVC1.movie = movies[indexPath.row]
            }
        } else {
            if let destVC2 = segue.destination as? GenreViewController,
               let indexPaths = collectionView.indexPathsForSelectedItems{
                if let indexPath = indexPaths.first{
                    let genreId = self.genreIds[indexPath.row]
                    
                    destVC2.genre = self.genres[indexPath.row]
                    destVC2.genreId = genreId
                }
            }
        }
    }
    

}
