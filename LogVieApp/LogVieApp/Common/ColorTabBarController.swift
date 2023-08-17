//
//  ColorTabBarController.swift
//  LogVieApp
//
//  Created by a0000 on 2021/11/23.
//

import UIKit

class ColorTabBarController: UITabBarController {
//    var imageInsets:UIEdgeInsets
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor(red: 139.0/255.0, green: 97.0/255.0, blue: 53.0/255.0, alpha: 1.0)
//        self.tabBar.isTranslucent = false
         self.tabBar.barTintColor = UIColor(red: 242.0/255.0, green: 240.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        self.tabBar.unselectedItemTintColor = UIColor(red: 42.0/255.0, green: 48.0/255.0, blue: 69.0/355.0, alpha: 1)
        
        let bg = UIColor(named: "bgColor")
        self.view.backgroundColor = bg
        
        /*if let storedNick = UserDefaults.standard.string(forKey: "nickname"){
            
        } else {
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginViewController {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
            
        }*/
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 95
        tabBar.frame.origin.y = view.frame.height - 95
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

//extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//    var sizeThatFits = super.sizeThatFits(size)
//    sizeThatFits.height = 50 // 원하는 길이
//    return sizeThatFits
//   }
//}
