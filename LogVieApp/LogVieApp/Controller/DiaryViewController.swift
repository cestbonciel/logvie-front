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

   
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnDiary: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet weak var viewDiary: UIView!

    
    @IBOutlet weak var lblUserNick: UILabel!
    
   
    
    var dates:[String] = []
    var diaryTVC:DiaryTableViewController?
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        let strdate = formatter.string(from: date)
        
        diaryTVC?.getDiaryData(strDate: strdate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewCalendar.delegate = self
        viewCalendar.dataSource = self
        
        imgViewProfile.layer.cornerRadius = 32.5
        
        viewCalendar.scope = .month
        viewCalendar.backgroundColor = UIColor(red: 242/255, green: 240/255, blue: 237/255, alpha: 1)
        viewCalendar.frame = CGRect(x: 0, y: 0, width: 374, height: 220)
        
        viewCalendar.layer.cornerRadius = 10
        
        viewCalendar.appearance.weekdayTextColor = UIColor(red: 42/255, green: 48/255, blue: 69/255, alpha: 1)
        viewCalendar.appearance.headerTitleColor = UIColor(red: 42/255, green: 48/255, blue: 69/255, alpha: 1)
        viewCalendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 18)
        viewCalendar.appearance.eventDefaultColor = UIColor(red: 139/255, green: 97/255, blue: 53/255, alpha: 1)
        viewCalendar.appearance.selectionColor = UIColor(red: 247/255, green: 142/255, blue: 16/255, alpha: 0.75)
        viewCalendar.appearance.todayColor = UIColor(red: 255/255, green: 216/255, blue: 77/255, alpha: 0.8)
        
        btnDiary.frame = CGRect(x: 200, y: 430, width: 95, height: 32)
        btnFavorite.frame = CGRect(x: 300, y: 430, width: 95, height: 32)
//        viewTable.frame = CGRect(x: 20, y: 470, width: 374, height: 426)
        viewDiary.frame = CGRect(x: 0, y: 0, width: 374, height: 426)
//        viewBookmark.frame = CGRect(x: 0, y: 0, width: 374, height: 426)
        
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            lblUserNick.text = "\(nickname) 님의"
        }
//        let nickname = UserDefaults.standard.string(forKey: "nickname")
//        guard let nickname = nickname else {
//            return lblUserNick.text = "\(nickname) 님의"
//        }
//        get()
        
        // 임시 프로필 이미지
        imgViewProfile.image = UIImage(named: "logo_eng")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.data(forKey: "profile_image"){
            imgViewProfile.image = UIImage(data: data)
            imgViewProfile.contentMode = .scaleAspectFill
        }
        
        if let nickName = UserDefaults.standard.string(forKey: "nickname"){
            lblUserNick.text = nickName
        }
        
        get()
    }
    
    public func reloadData(){
        if let data = UserDefaults.standard.data(forKey: "profile_image"){
            imgViewProfile.image = UIImage(data: data)
        }
        
        if let nickName = UserDefaults.standard.string(forKey: "nickname"){
            lblUserNick.text = nickName
        }
        
        get()
    }
    
    func get(){
//        let strURL = "http://52.231.64.183:8000/logvie_app/diaries/"
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
        dateformatter.dateFormat = "yyyy년 M월 d일"
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
//            viewTable.frame = CGRect(x: 20, y: 340, width: 374, height: 556)
            viewDiary.frame = CGRect(x: 0, y: 0, width: 374, height: 556)
            viewCalendar.layoutIfNeeded()
//            viewBookmark.frame = CGRect(x: 0, y: 0, width: 374, height: 556)
        } else {
            viewCalendar.scope = .month
            viewCalendar.frame = CGRect(x: 20, y: 200, width: 374, height: 220)
            btnDiary.frame = CGRect(x: 200, y: 430, width: 95, height: 32)
            btnFavorite.frame = CGRect(x: 300, y: 430, width: 95, height: 32)
//            viewTable.frame = CGRect(x: 20, y: 470, width: 374, height: 426)
            viewDiary.frame = CGRect(x: 0, y: 0, width: 374, height: 426)
            viewCalendar.layoutIfNeeded()
//            viewBookmark.frame = CGRect(x: 0, y: 0, width: 374, height: 426)
        }
    }
    
    @IBAction func actDiary(_ sender: Any) {
//        viewDiary.alpha = 1
//        viewBookmark.alpha = 0
    }


    
    //작성버튼 관련 액션 - 서현
    @IBAction func actWriting(_ sender: Any) {
        let sb = UIStoryboard(name: "WriteDiary", bundle: nil)
        let vc2 = sb.instantiateViewController(withIdentifier:"WritingDiary")
        vc2.modalPresentationStyle = .fullScreen
        self.present(vc2, animated:true, completion: nil)
        //self.tabBarController?.selectedIndex =
    }
    
    @IBAction func segueBtn(_ sender: Any) {
        //스토리보드ID를 참조하여 뷰 컨트롤러를 가져온다.
        guard let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "DiaryProfile") as? DiaryProfileViewController else {
            return
        }
        profileVc.diaryVC = self
        //인자값으로 다음 뷰 컨트롤러를 넣고 present 메소드를 호출합니다.
        self.present(profileVc, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        if segue.identifier == "diary_list"{
            self.diaryTVC = segue.destination as? DiaryTableViewController
            diaryTVC?.getDiaryData()
//        } else {
//            
//        }
    }
    

}

extension DiaryViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
