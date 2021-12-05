//
//  HomeViewController.swift
//  LogVieApp
//
//  Created by a0000 on 2021/11/29.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // 로그인 정보 유무 ( 로그인 유지 환경) 
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "nickname") == nil{
            if let loginVC = UIStoryboard(name:"Home",bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginViewController {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
            self.tabBarController?.selectedIndex = 0
        }
        /*if UserDefaults.standard.string(forKey: "nickname") == nil{
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginViewController {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
            self.tabBarController?.selectedIndex = 0
        }*/
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
