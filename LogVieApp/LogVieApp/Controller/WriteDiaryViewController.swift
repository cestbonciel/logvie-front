//
//  WriteDiaryViewController.swift
//  LogVieApp
//
//  Created by a0000 on 2021/11/29.
//

import UIKit
import Alamofire
import SwiftyJSON

class WriteDiaryViewController: UIViewController {


    let myColor = UIColor(red: 133.0/255.0, green: 99.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var movieTit: UITextField!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var diaryText: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!

    // 기분 감정 버튼
    @IBOutlet var buttons: [UIButton]!
    var moodLib:Int = 1
    var userId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTit.hideUnderLine()
        imageView.layer.borderColor = myColor.cgColor
        imageView.layer.borderWidth = 1.5
        datePicker.datePickerMode = .dateAndTime
        
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            self.userId = uid
        }
        
    }
    
//    func register(user)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   

    @IBAction func actSave(_ sender: Any) {
        
        let dataformatter = DateFormatter()
        dataformatter.dateFormat = "yyyy-MM-dd"
        let datestr = dataformatter.string(from: datePicker.date)
        let photo = UIImage(named:"logo_eng")
    
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let title = movieTit.text,
              let diaryTxt = diaryText.text else {
            return
        }

        let params:Parameters = ["user_id":userId,
                                 "writing_date":datestr,
                                 "movie_title":title,
                                 "diary_text":diaryTxt,
                                 "photo":"logo_eng.png",
                                 "mood":moodLib ]
        post(params:params)
    }
    
    @IBAction func getMood(_ sender: UIButton) {
        for button in buttons{
            button.backgroundColor = .clear
        }
        
        moodLib = sender.tag
        sender.backgroundColor = UIColor(displayP3Red: 42.0/255.0, green: 48.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        sender.layer.cornerRadius = sender.layer.frame.height/2
        sender.clipsToBounds = true
        
    }
    
    func post(params:Parameters){
        let strURL = "http://localhost:8000/logvie_app/diaries/"
        let request = AF.request(strURL, method: .post,parameters: params)
        
        request.responseDecodable(of:BackEndResponse.self) { response in
            switch response.result{
            case .failure(let error):
                print(error.errorDescription ?? "error")
            case .success(let res):
                if res.result == "success"{
                    let successAlert = UIAlertController(title: "작성완료", message: "작성이 완료되었습니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { action in
                        print("성공")
                    }
                    successAlert.addAction(action)
                    self.dismiss(animated: true)
                } else {
                    let failedAlert = UIAlertController(title: "작성실패", message: "비어 있는 것을 작성해주세요", preferredStyle: .alert)
                    let action2 = UIAlertAction(title: "확인", style: .default) { action2 in
                        print("error")
                    }
                    self.present(failedAlert, animated: true)
                }
                
            }
        }
    }
    
    @IBAction func actCancel(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    

}

extension UITextField {
    func hideUnderLine() {
        let myColor = UIColor(red: 133.0/255.0, green: 99.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        let border = CALayer()

        border.borderColor = myColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width:  self.frame.size.width, height:1)
        
        border.backgroundColor = myColor.cgColor
        borderStyle = .none
        layer.addSublayer(border)

    }
}
