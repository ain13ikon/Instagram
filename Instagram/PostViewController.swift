//
//  PostViewController.swift
//  Instagram
//
//  Created by きたむら on 2018/09/13.
//  Copyright © 2018年 ain13ikon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage! //カメラ・ライブラリから取得した画像

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    //投稿ボタンがタップされた時
    @IBAction func handlePostButton(_ sender: UIButton) {
        //ImageViewから画像を取得し、UIImageJPEG~メソッドでJPEG形式のDataクラスに変換
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
        //JPEG画像をBase64方式でテキスト形式に変換
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        let time = Date.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        //データベース上の保存先を取得
        let postRef = Database.database().reference().child(Const.PostPath)
        //保存するデータを辞書にまとめる
        let postDic = ["caption": textField.text!, "image": imageString, "time": String(time), "name": name!]
        postRef.childByAutoId().setValue(postDic)
        
        //HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        print("投稿しました")
        
        //全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //キャンセルボタンがタップされた時
    @IBAction func handleCancelButton(_ sender: Any) {
        print("デバッグ：　投稿がキャンセルされました")
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //遷移前から受け取った画像をImageViewに設定する
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
