//
//  WriteDiaryDetailViewController.swift
//  LogVieApp
//
//  Created by a0000 on 2021/12/02.
//

import UIKit
import Alamofire

class WriteDiaryDetailViewController: UIViewController {
    var numOfPage:Int?
    var diary:DiaryWriting.Writings?
    let containerName = "logvieimgs"
    
    @IBOutlet weak var moodImoji: UILabel!
    @IBOutlet weak var writtenDate: UILabel!
    @IBOutlet weak var diaryMovietit: UILabel!
    @IBOutlet weak var moviePhoto: UIImageView!
    //@IBOutlet weak var movieDiaryTxt: UILabel!
//    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieDiaryTxt: UITextView!
    //수정창
    @IBOutlet weak var editWrittenDate: UIDatePicker!
    @IBOutlet weak var editDiaryMovietit: UITextField!
    @IBOutlet weak var editMovieDiaryTxt: UITextView!
    @IBOutlet var editMoodImoji: [UIButton]!
    @IBOutlet weak var editDiaryText: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /*
        
        diaryMovietit.text =  diaries.movieTitle
        movieDiaryTxt.text = diaries.diaryText
        writtenDate.text = diaries.writingDate
        moodImoji.text = moodIcon[(diaries.mood-1)]
         let photo = diaries.photo
         photo.image = UIImage(named:photo)
         */
        
        guard let diary = diary else {
            return
        }

        writtenDate.text = diary.writingDate
        let moodIndex = diary.mood - 1
        moodImoji.text = moodIcon[moodIndex]
        diaryMovietit.text = diary.movieTitle
        movieDiaryTxt.text = diary.diaryText
        
        if diary.photo == "logo_eng"{
            moviePhoto.image = UIImage(named: "logo_eng")
        } else {
            
            let imagename = diary.photo as NSString
            
            if let image = ImageCacheManager.shared.object(forKey: imagename){
                moviePhoto.image = image
            } else {
                let blobImage = AZBlobImage(containerName: "logvieimgs")
                blobImage.downloadImage(blobName: diary.photo, imageView: moviePhoto) { image in
                    if let image = image {
                        ImageCacheManager.shared.setObject(image, forKey: imagename)
                    }
                    
                }
            }
            
            //textView
            movieDiaryTxt.layer.borderColor = .init(red: 133.0/255.0, green: 99.0/255.0, blue: 60.0/255.0, alpha: 1.0)
            movieDiaryTxt.layer.borderWidth = 2
            
        }
        
        
       
         
//        if let diary.photo = "logo_eng" {
//            moviePhoto.image = UIImage(named: "logo_eng")
//        } else {
//            if let data = moviePhoto.image?.pngData(){
//                UserDefaults.standard.set(data, forKey: "movieDiary_photo")
//            }
//            if let data = UserDefaults.standard.data(forKey: "movieDiary_photo"){
//                moviePhoto.image = UIImage(data: data)
//            }
//        }
        
        /*
         
         if let data = userProfilephoto.image?.pngData(){
             UserDefaults.standard.set(data, forKey: "profile_image")
         }
         
         if let data = UserDefaults.standard.data(forKey: "profile_image"){
             userProfilephoto.image = UIImage(data: data)
         } else {
             let photo  = UIImage(named:"logo2")
             userProfilephoto.image = photo
         }
         
         */
        
    }
    
    @IBOutlet var diaryView: UIView!
    
//    func getDiaryData(){
//        let uid = UserDefaults.standard.string(forKey: "user_id")
//        let strURL = "http://localhost:8000/logvie_app/diaries/"
//
//        let request = AF.request(strURL, method:.get, parameters:["user_id":uid])
//        request.responseDecodable(of:DiaryWriting.self) { response in
//
//            switch (response.result){
//            case .success(let diaryWriting):
//                let diary = self.diary
//                if let diary = diary {
//                    self.diary = diaryWriting.data
//                }
//
//                DispatchQueue.main.async {
//                    self.diaryView.reloadInputViews()
//                }
//
//            case .failure(let error):
//                print(error.errorDescription)
//            }
//
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @IBAction func editDiary(_ sender: Any) {
//        
//    }
    
}
