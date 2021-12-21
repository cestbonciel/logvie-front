//
//  HomeViewController.swift
//  LogVieApp
//
//  Created by a0000 on 2021/11/29.
//

import UIKit
import Alamofire
import SDWebImage

class HomeViewController: UIViewController {
    var posters:[String] = []
    var titles:[String] = []
    var index = 0

    var isAnimating = false

    let posterBaseURL = "https://image.tmdb.org/t/p/w500"

    var visualImageView = UIImageView()
    var hiddenImageView = UIImageView()
    
    var preFrame:CGRect = CGRect()
    var nextFrame:CGRect = CGRect()
    var currentFrame:CGRect = CGRect()
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.addSubview(visualImageView)
        container.addSubview(hiddenImageView)
        
        currentFrame = container.bounds
        preFrame = CGRect(x: currentFrame.width+100, y: 0, width: currentFrame.width, height: currentFrame.height)
        
        nextFrame = CGRect(x: -currentFrame.width-100, y: 0, width: currentFrame.width, height: currentFrame.height)
        
        visualImageView.frame = currentFrame
        btnPrev.isEnabled = false
        
        getMovie()
        
        lblRank.layer.shadowOffset = CGSize(width: 3, height: 3)
        lblRank.layer.shadowOpacity = 0.8
        lblRank.layer.shadowRadius = 2
        lblRank.layer.shadowColor = CGColor.init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.nextImage))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.prevImage))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if UserDefaults.standard.string(forKey: "nickname") == nil{
//            if let loginVC = UIStoryboard(name:"Home",bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginViewController {
//                loginVC.modalPresentationStyle = .fullScreen
//                self.present(loginVC, animated: true)
//            }
//            self.tabBarController?.selectedIndex = 0
//        }
//        getMovie()
    }
    
    
    func getMovie(){
        let endPoint = "https://api.themoviedb.org/3/movie/now_playing?page="
        let apiKey = "2b776cd7a06fe6316152d5c1ac2fecb1"
        
        let params:Parameters = ["api_key":apiKey, "language":"ko-KR", "page":1]
        
        let request = AF.request(endPoint, method: .get, parameters: params)
        request.responseDecodable(of: MovieInfo.self) { response in
            switch response.result{
            case.failure(let error):
                print(error.localizedDescription)
            case.success(let movieInfo):
                let movies = movieInfo.results
                for movie in movies {
                    let movieTitle = movie.title
                    self.titles.append(movieTitle)

                    let moviePoster = movie.posterPath
                    self.posters.append(moviePoster)
                }
                guard let movie = movies.first else {return}

                
                self.lblRank.text = "\(self.index+1)"

                
                let firstTitle = movie.title
                self.lblTitle.text = firstTitle

                let firstPoster = movie.posterPath
                let firstFullPoster = "\(self.posterBaseURL)\(firstPoster)"
                self.visualImageView.sd_setImage(with: URL(string: firstFullPoster), completed: nil)

            }
        }
    }
    

    @objc func prevImage(){
        if isAnimating || index<1 { return }
        isAnimating = true
        btnNext.isEnabled = true
        btnPrev.isEnabled = true
        index-=1
        if index==0{
            btnPrev.isEnabled = false
        }
        
        let posterPath = self.posters[self.index]
        let posterFullPath = "\(posterBaseURL)\(posterPath)"
        hiddenImageView.sd_setImage(with: URL(string: posterFullPath), completed: nil)
        hiddenImageView.frame = nextFrame
        
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.hiddenImageView.frame = self.currentFrame
            self.visualImageView.frame = self.preFrame
        } completion: { _ in
            let tempImageView = self.hiddenImageView
            self.hiddenImageView = self.visualImageView
            self.visualImageView = tempImageView
            self.lblTitle.text = self.titles[self.index]
            self.lblRank.text = "\(self.index+1)"
            self.isAnimating = false
        }
    }
    
    @IBAction func actPrev(_ sender: UIButton) {
        prevImage()

    }
    
    @objc func nextImage(){
        if isAnimating{return}
        isAnimating = true
        btnNext.isEnabled = true
        btnPrev.isEnabled = true
        index+=1
        if index>=titles.count-1{
            btnNext.isEnabled = false
        }
        
        let posterPath = self.posters[self.index]
        let posterFullPath = "\(posterBaseURL)\(posterPath)"
        hiddenImageView.sd_setImage(with: URL(string: posterFullPath), completed: nil)
        hiddenImageView.frame = preFrame
        
        UIView.animate(withDuration: 0.4, delay: 0, options: []) {
            self.hiddenImageView.frame = self.currentFrame
            self.visualImageView.frame = self.nextFrame
        } completion: { _ in
            let tempImageView = self.hiddenImageView
            self.hiddenImageView = self.visualImageView
            self.visualImageView = tempImageView
            self.lblTitle.text = self.titles[self.index]
            self.lblRank.text = "\(self.index+1)"
            self.isAnimating = false
        }
    }
    
    @IBAction func actNext(_ sender: UIButton) {
        nextImage()
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
