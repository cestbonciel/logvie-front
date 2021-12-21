//
//  DiaryTableViewController.swift
//  LogVieApp
//
//  Created by today0818 on 2021/11/28.
//

import UIKit
import Alamofire
import SwiftyJSON

class DiaryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let containerName = "logvieimgs"
    var diaries:[DiaryWriting.Writings]?
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var diaryTableImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 130
    }
    
//    public func reloadMovies(){
//        getDiaryData()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDiaryData()
    }
    // 데이터 테이블 뷰에 show
    public func getDiaryData(strDate:String?=nil){
        guard let uid = UserDefaults.standard.string(forKey: "user_id") else { return }
        var strURL = ""
        
        var params:Parameters = [:]
        
        if let strDate = strDate {
//            strURL = "http://52.231.64.183:8000/logvie_app/diaries_date"
            strURL = "http://localhost:8000/logvie_app/diaries_date"
            params = ["user_id":uid, "writing_date":strDate]
            let request = AF.request(strURL, parameters: params)
            request.responseDecodable(of:[DiaryWriting.Writings].self) { response in
                
                switch (response.result){
                case .success(let writings):
                    self.diaries = writings
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error.errorDescription ?? "error")
                }
            }
        } else {
//            strURL = "http://52.231.64.183:8000/logvie_app/diaries/"
            strURL = "http://localhost:8000/logvie_app/diaries/"
            params = ["user_id":uid]
            let request = AF.request(strURL, parameters: params)
            request.responseDecodable(of:DiaryWriting.self) { response in
                
                switch (response.result){
                case .success(let diaryWriting):
                    self.diaries = diaryWriting.data
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error.errorDescription ?? "error")
                }
            }
        }
        
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let diaries = diaries {
            return diaries.count
            
        } else {
            return 0
        }
//        guard let diaryLength =  diaries?.count else { return }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath)
        guard let diaries = diaries else {
            return cell
        }
//        cell.layer.masksToBounds = true
//        cell.layer.cornerRadius = 5
//        cell.layer.borderWidth = 2
//        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
//        let borderColor: UIColor = (diaries[indexPath.row] == "inStock") ? .red : .green
//        cell.layer.borderColor = borderColor.cgColor
        var imageName = ""
        let diary = diaries[indexPath.row]
        if let movieTit = cell.viewWithTag(2) as? UILabel {
            movieTit.text = diary.movieTitle
        }
        if let movieTxt = cell.viewWithTag(3) as? UILabel{
            movieTxt.text = diary.diaryText
        }
        if let watchDate = cell.viewWithTag(4) as? UILabel{
            watchDate.text = diary.writingDate
        }
        if let mood = cell.viewWithTag(5) as? UILabel{
            mood.text = moodIcon[(diary.mood-1)]
        }
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            if diary.photo == "logo_eng"{
                imageView.image = UIImage(named: "logo_eng")
            } else {
                let blobName = diary.photo
                let blobImage = AZBlobImage(containerName: containerName)                
                DispatchQueue.main.async {
                    blobImage.downloadImage(blobName: blobName, imageView: imageView) { _ in
                        
                        //                DispatchQueue.main.async {
                        //                    let image = UIImage(data: data)
                        //                    imageView.image = image
                        //                }
                    }
                }
            }
            
        }
        return cell
        
    }
    //        lblTitle.text = title
    //        return cell
    
    func removeDiary(id:Int){

//        let strURL = "http://52.231.64.183:8000/logvie_app/diaries/\(id)"
        let strURL = "http://localhost:8000/logvie_app/diaries/\(id)"
//    http://0.0.0.0:8000/logvie_app/favorites/
        let request = AF.request(strURL, method:.delete)
//        let request = AF.request(strURL, method:.delete, parameters:["user_id":uid ?? "user_id","id":id])
        request.responseDecodable(of: DiaryWriting.self) { response in
            switch response.result{
            case .success(let diaryWriting):
                self.diaries = diaryWriting.data
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.errorDescription ?? "error")
            }
        }
    }
    
    //    guard let diaries = diaries else { return }
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                /*tableView.beginUpdates()
    //            getDiaryData(indexPath.row)
                if let diary = self.diaries?[indexPath.row]{
                    removeDiary(id: diary.id)
                }
                self.diaries?.remove(at: indexPath.row)
//                guard let diary = self.diaries?[indexPath.row] else { return }
                //diary.id()
    //            removeDiary(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()*/
                guard let diary = self.diaries?[indexPath.row] else { return }
                let deletedId = diary.id
                removeDiary(id: deletedId)
                
                self.diaries?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if segue.identifier == "WriteDiaryDetailView" {
             let vc = segue.destination as? WriteDiaryDetailViewController
             if let indexPath = tableView.indexPathForSelectedRow{
                 vc?.diary = self.diaries?[indexPath.row]
             }
         }
         
     }
    

}
