//
//  LoginViewController.swift
//  LogVieApp
//
//  Created by a0000 on 2021/11/23.
//

import UIKit

class LoginViewController: UIViewController{
    var userId: String?
    var diaryVC: DiaryViewController?
  
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*if let storedNick = UserDefaults.standard.string(forKey: "nickname"){
        
            textField.text = storedNick
        }*/

        
    }
    // keyboard on / off ( when touches mobile screen)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func actSave(_ sender: UIButton) {
        // 입력 아예 안하고 입장시 에러 창
        /*guard self.textField.text?.isEmpty == false else {
            
            let alert = UIAlertController(title: nil, message: "닉네임을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default){_ in
                
                self.navigationController?.popViewController(animated: true)
                
            })
            self.present(alert, animated: true)
            return
            
        }*/
        
        guard let input = textField.text else { return }
        let inputLength = input.count
        //textfield 안 값 5자 미만 10 자 이내
        if (3...10).contains(inputLength) { //if input.count > 10
            UserDefaults.standard.setValue(input, forKey: "nickname")
            userId = UUID().uuidString
            UserDefaults.standard.setValue(userId, forKey: "user_id")
            
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "닉네임이름", message: "닉네임을 3자 이상 10자 이내로 작성하시오", preferredStyle:.alert)
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                print("확인이 눌러졌습니다.") }
            alert.addAction(action)
            present(alert, animated: true) 
        }
        
        let tabBarVC = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "tabBar")
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
//           window?.rootViewController = tabBarVC
//        let tabBarVC = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "tabbar")
//                tabBarVC.modalPresentationStyle = .fullScreen
//                present(tabBarVC, animated: true)
        
        
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
      
        }
    }
    */

}
