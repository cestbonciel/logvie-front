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
    
    var diaries:[DiaryWriting.Writings]?
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 130
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDiaryData()
        tableView.reloadData()
    }

    func getDiaryData(){
        let uid = UserDefaults.standard.string(forKey: "user_id")
        let strURL = "http://localhost:8000/logvie_app/diaries/"
        
        let request = AF.request(strURL, method:.get, parameters:["user_id":uid])
        request.responseDecodable(of:DiaryWriting.self) { response in
            switch (response.result){
            case .success(let diaryWriting):
                self.diaries = diaryWriting.data
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.errorDescription)
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
        if let photo = cell.viewWithTag(1) as? UIImageView {
            let imageName = diary.photo
//            print(imagename)
            photo.image = UIImage(named: imageName)
        }
        return cell
    }
//        lblTitle.text = title
//        return cell
    
    func removeDiary(id:Int){
        let uid = UserDefaults.standard.string(forKey: "user_id")
        let strURL = "http://localhost:8000/logvie_app/diaries/"
        let request = AF.request(strURL, method:.delete, parameters:["user_id":uid ?? "user_id","id":id])
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
                tableView.beginUpdates()
    //            getDiaryData(indexPath.row)
                self.diaries?.remove(at: indexPath.row)
                
                guard let diary = self.diaries?[indexPath.row] else { return }
                //diary.id()
    //            removeDiary(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
            }
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
