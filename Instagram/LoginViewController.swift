//
//  LoginViewController.swift
//  Instagram
//
//  Created by きたむら on 2018/09/13.
//  Copyright © 2018年 ain13ikon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    //ログインボタンをタップした時に呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            if address.isEmpty || password.isEmpty {
                print("デバッグ：　空の入力があります")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) {user, error in
                if let error = error {
                    print("デバッグ：　エラー：　" + error.localizedDescription)
                    return
                }else{
                    print("デバッグ：　ログインに成功しました")
                    
                    //HUDを消す
                    SVProgressHUD.dismiss()
                    
                    //画面を閉じてViewControllerに戻る
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    //アカウント作成ボタンをタップした時に呼ばれるメソッド
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            

                if address.isEmpty || password.isEmpty || displayName.isEmpty {
                    print("デバッグ：　空の入力欄があります")
                    SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                    return
                }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
        
            
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { user, error in
                //メモ：createUserメソッド(アカウント作成)で返されたuserとerror(結果とエラー)を用いたクロージャ
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("デバッグ: エラー：" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        //HUDを消す
                        SVProgressHUD.dismiss()
                        
                        // 画面を閉じてViewControllerに戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("デバッグ：　ログイン画面に移りました")
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
