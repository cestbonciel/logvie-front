//
//  DiaryViewController.swift
//  LogVieApp
//
//  Created by a0000 on 2021/11/27.
//

import UIKit
import Alamofire
import FSCalendar

class DiaryViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var viewCalendar: FSCalendar!
    @IBOutlet weak var viewTable: UIView!
    
    @IBOutlet weak var btnDiary: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet weak var viewDiary: UIView!
    @IBOutlet weak var viewBookmark: UIView!
    
    @IBOutlet weak var lblUserNick: UILabel!
    
    var dates:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewCalendar.delegate = self
        viewCalendar.dataSource = self
        
        imgViewProfile.layer.cornerRadius = 32.5
        
        viewCalendar.scope = .month
        viewCalendar.backgroundColor = UIColor(red: 242/255, green: 240/255, blue: 237/255, alpha: 1)
        viewCalendar.frame = CGRect(x: 20, y: 200, width: 374, height: 220)
        
        btnDiary.frame = CGRect(x: 200, y: 430, width: 95, height: 32)
        btnFavorite.frame = CGRect(x: 300, y: 430, width: 95, height: 32)
        viewTable.frame = CGRect(x: 20, y: 470, width: 374, height: 426)
        viewDiary.frame = CGRect(x: 0, y: 0, width: 374, height: 426)
        viewBookmark.frame = CGRect(x: 0, y: 0, width: 374, height: 426)
        
        let nickname = UserDefaults.standard.string(forKey: "nickname")
        lblUserNick.text = nickname
        
        get()
    }
    
    func get(){
        let strURL = "http://localhost:8000/logvie_app/diaries/"
        let request = AF.request(strURL, method: .get)
        request.responseDecodable(of: DiaryWriting.self) { response in
            switch response.result{
            case.failure(let error):
                print(error.errorDescription ?? "error")
                print("get 실패")
            case.success(let diaryWriting):
                let diaries = diaryWriting.data
                for diary in diaries{
                    let date = diary.writingDate
                    self.dates.append(date)
                    DispatchQueue.main.async {
                        self.viewCalendar.reloadData()
                    }
                }
            }
        }

    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let calDate = dateformatter.string(from: date)
        
        if self.dates.contains(calDate){
            return 1
        } else {
            return 0
        }
    }
    
    @IBAction func actCalendar(_ sender: Any) {
        if viewCalendar.scope == .month {
            viewCalendar.scope = .week
            viewCalendar.frame = CGRect(x: 20, y: 200, width: 374, height: 90)
            btnDiary.frame = CGRect(x: 200, y: 300, width: 95, height: 32)
            btnFavorite.frame = CGRect(x: 300, y: 300, width: 95, height: 32)
            viewTable.frame = CGRect(x: 20, y: 340, width: 374, height: 556)
            viewDiary.frame = CGRect(x: 0, y: 0, width: 374, height: 556)
            viewBookmark.frame = CGRect(x: 0, y: 0, width: 374, height: 556)
        } else {
            viewCalendar.scope = .month
            viewCalendar.frame = CGRect(x: 20, y: 200, width: 374, height: 220)
            btnDiary.frame = CGRect(x: 200, y: 430, width: 95, height: 32)
            btnFavorite.frame = CGRect(x: 300, y: 430, width: 95, height: 32)
            viewTable.frame = CGRect(x: 20, y: 470, width: 374, height: 426)
            viewDiary.frame = CGRect(x: 0, y: 0, width: 374, height: 426)
            viewBookmark.frame = CGRect(x: 0, y: 0, width: 374, height: 426)
        }
    }
    
    @IBAction func actDiary(_ sender: Any) {
        viewDiary.alpha = 1
        viewBookmark.alpha = 0
    }
    @IBAction func actFavorite(_ sender: Any) {
        viewDiary.alpha = 0
        viewBookmark.alpha = 1

    }
    //    @IBAction func actSegCon(_ sender: Any) {
//        if segCon.selectedSegmentIndex == 0 {
//            viewDiary.alpha = 1
//            viewBookmark.alpha = 0
//        } else {
//            viewDiary.alpha = 0
//            viewBookmark.alpha = 1
//        }
//    }
    
    //작성버튼 관련 액션 - 서현
    @IBAction func actWriting(_ sender: Any) {
        let sb = UIStoryboard(name: "WriteDiary", bundle: nil)
        let vc2 = sb.instantiateViewController(withIdentifier:"WritingDiary")
        vc2.modalPresentationStyle = .fullScreen
        self.present(vc2, animated:true, completion: nil)
        //self.tabBarController?.selectedIndex =
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
