//
//  DiaryProfileViewController.swift
//  LogVieApp
//
//  Created by cgung63 on 2021/11/29.
//

import UIKit

class DiaryProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //닉네임 수정

    var diaryVC:DiaryViewController?
    
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var userProfilephoto: UIImageView!
    //이미지 수정
    
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        picker.delegate = self
        // 이미지뷰 크기
//        userProfilephoto.layer.cornerRadius = 32.5
        // 프로필 이미지 둥글게 마스크 처리
//           self.userProfilephoto.layer.cornerRadius = self.userProfilephoto.frame.width / 2
//           self.userProfilephoto.layer.borderWidth = 2
//           self.userProfilephoto.layer.masksToBounds = true
//           self.view.addSubview(self.userProfilephoto)
        
        let myColor = UIColor(red: 133.0/255.0, green: 99.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        userProfilephoto.layer.borderColor = myColor.cgColor
        userProfilephoto.layer.borderWidth = 2
                
        nickNameTextField.hiddenUnderLine()
        
        if let data = UserDefaults.standard.data(forKey: "profile_image"){
            userProfilephoto.image = UIImage(data: data)
        } else {
            let photo = UIImage(named:"logo2")
            userProfilephoto.image = photo
        }
        
        //배경색
//           self.view.backgroundColor = UIColor(red: 242/255, green: 240/255, blue: 237/255, alpha: 1)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    

    // 버튼_갤러리 열기
    @IBAction func btnLibrary(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true) }
    
    // 저장 액션
    @IBAction func submitButton(_ sender: Any) {
        //텍스트 전달
        if let newNick = nickNameTextField.text {
            UserDefaults.standard.set(newNick, forKey: "nickname")
        }
        
        if let data = userProfilephoto.image?.pngData(){
            UserDefaults.standard.set(data, forKey: "profile_image")
        }
            
//        UserDefaults.standard.set("logo2.png", forKey: "profile_image")
        dismiss(animated: true){
            self.diaryVC?.reloadData()
        }
        
    }
    
    
    
    // 버튼_취소
    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true) }



    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage{
            userProfilephoto.image = image
        let rotatedImage = rotateImage(image: image)
        let data = rotatedImage?.pngData()
        //runtime 때 경로를 가지고 오는 걸 해야함.
        try? data?.write(to: getFileName()) }//try? : 에러가 나면 nil 을 반환
    }
    
    //파일 저장 시 이름 중복되지 않게 설정해주는 것
    func getFileName()->URL{
        let uniqueName = ProcessInfo.processInfo.globallyUniqueString
        let filename = getDocuments().appendingPathComponent("img_\(uniqueName).png")
        print(filename)
        return filename
    }
    
    func getDocuments()->URL{
        //singleton 객체, sandbox 랑 연관이 있음
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
    
    func rotateImage(image:UIImage)->UIImage?{
        if(image.imageOrientation == UIImage.Orientation.up){
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
} //클래스 닫음

extension UITextField {
    func hiddenUnderLine() {
        let myColor = UIColor(red: 133.0/255.0, green: 99.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        let border = CALayer()

        border.borderColor = myColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width:  self.frame.size.width, height:1)
        
        border.backgroundColor = myColor.cgColor
        borderStyle = .none
        layer.addSublayer(border)

    }
}
