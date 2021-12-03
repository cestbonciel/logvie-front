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
        
        tableView.rowHeight = 100
    }
    
    
    /*
     var id:Int
     var userId:UUID
     var writingDate:String
     var movieTitle:String
     var diaryText:String
     var photo:String
     var mood:Int
     */
    func getDiaryData(){
        let strURL = "http://localhost:8000/logvie_app/diaries"
        let request = AF.request(strURL, method:.get)
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
            mood.text = moodIcon[diary.mood]
        }
        return cell
    }
//        lblTitle.text = title
//        return cell
    
    /*
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        <#code#>
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
