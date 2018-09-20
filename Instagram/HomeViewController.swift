//
//  HomeViewController.swift
//  Instagram
//
//  Created by きたむら on 2018/09/13.
//  Copyright © 2018年 ain13ikon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var postDataComments: [[String: String]] = []

    //表示するデータ(PostDataクラス)を配列で保持
    var postArray: [PostData] = []
    
    //DatabaseのobserveEventの登録状態を表す
    var observingF = false
    
    //データ（セル）の数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView === self.tableView{
            //tableViewのセル数//
            return postArray.count
        }else{
            //commentTableViewのセル数//
            print("コメントは\(postDataComments.count)件です")
            return postDataComments.count
        }
    }
    
    //表示するセルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === self.tableView{
            //tableViewセルの設定//
            print("デバッグ：　tableViewセルを設定します")
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
            //セルの作成
            cell.setPostData(postArray[indexPath.row])
            
            // いいねボタンのアクションをソースコードで設定する
            cell.likeButton.addTarget(self, action:#selector(handleLikeButton(_:forEvent:)), for: .touchUpInside)
            
            //コメントボタンのアクションをソースコードで設定する
            cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_: forEvent:)), for: .touchUpInside)
            
            //commentTableViewについての設定
            //セル内のcommentTableViewのデリゲートを設定
            cell.commentTableView.delegate = self
            cell.commentTableView.dataSource = self
            
            //テーブルセルのタップを無効にする
            cell.commentTableView.allowsSelection = false
            
            //テーブルビューの内容を取得
            let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
            cell.commentTableView.register(nib, forCellReuseIdentifier: "CommentCell")
            
            //コメント内容の取得
            postDataComments = postArray[indexPath.row].comments
            print("デバッグ：　コメントを取得")
            
            /*
            postDataComments = [
                 ["name": "花子",  "comment": "いいですねねねねねねねねねねねねねねねねねね！"],
                 ["name": "太郎",  "comment": "すごいー"],
                 ["name": "ごんたぬきのたぬき",  "comment": "あああああああああああああああ"]
            ]*/
            
            //コメント一覧の高さをコメント数によって調整する
            var commentTableHeight = CGFloat(postDataComments.count * 50)
            if commentTableHeight > 150 {
                commentTableHeight = 150
            }
            cell.commentTableViewConstraintHeight.constant = commentTableHeight
            
            return cell
            
        }else{
            //commentTableViewセルの設定//
            print("デバッグ：　commentTableViewセルを設定します")
            print("デバッグ：　コメントテーブルビュー")
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            print("デバッグ：　setPostCellData()します")
            cell.setPostCellData(postDataComments[indexPath.row])
            return cell
        }
    }
    
    //コメントボタンがタップされた時に呼ばれるメソッド
    @objc func handleCommentButton(_ sender: UIButton, forEvent event: UIEvent){
        print("DEBUG_PRINT: コメントボタンがタップされました。")
        if let user = Auth.auth().currentUser {
            // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: point)
            
            //print(commentLabel.text)
            //print(UITableViewCell(indexPath!.row).commentLabel.text)
            
            // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath!.row]
            
            //*コメント内容を取得する
            //タップされたボタンのセルのインデックスからCellを取り出す
            if let cell = tableView.cellForRow(at: indexPath!) as? PostTableViewCell{
                if let commentKari = cell.commentLabel.text {
                    if commentKari != ""{
                        print("デバッグ：　コメントが入力されています")
                        let comment = commentKari
                        
                        //コメント者を取得する
                        let commenter = user.displayName!
                        print("デバッグ：　\(comment) by\(commenter)")
                        
                        //*コメントをデータベースに保存する
                        //**投稿データの保存場所を取得する
                        //            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
                        //**投稿データのコメントに追加する
                        //            let newComment = ["comment": comment, "commenter": commenter]
                        //            postData.comments.insert(newComment, at: 0)
                        //**投稿データをアップデートする
                        //            postRef.updateChildValues(["comments": postData.comments])
                        //            print(postData.comments)

                    }else{
                        print("デバッグ：　コメントが入力されていません")
                    }
                }
                //入力欄をデフォルトに戻す
                cell.commentLabel.text = ""
                cell.commentLabel.placeholder = "コメントを追加"
            }

 
        }
    }
    
    // いいねボタンがタップされた時に呼ばれるメソッド
    @objc func handleLikeButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if postData.isLiked {
                //いいねをしていた場合//
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1  //０、整数以外。removeしないため
                for likeId in postData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                //いいねをしていない場合→いいねをする//
                postData.likes.append(uid)
            }
            
            // 増えたlikesをFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            //let likes = ["likes": postData.likes]
            postRef.updateChildValues(["likes": postData.likes])
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
        //テーブルビューの内容を取得
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableViewAutomaticDimension
        // テーブル行の高さの概算値を設定しておく
        // 高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("デバッグ：　viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            //ログインしている場合//
            
            if self.observingF == false{
                //要素が追加されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                //↑全部のデータ
                //↓１つずつ読み込んでpostDataを作成
                postsRef.observe(.childAdded, with: {snapshot in
                    print("デバッグ：　.childAddedイベントが発生しました")
                    
                    //PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        //PostDataのインスタンスを作成
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at:0)   //データ配列の一番最初に追加
                        
                        //TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
                
                //要素が変更されたら街灯のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childChanged, with: {snapshot in
                    print("デバッグ：　.childChangedイベントが発生しました")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!
                                //メモ：　index(of: 値)は配列中で初めて値が現れる場所の要素数を返す
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        // 削除したところに更新済みのデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
                
                // DatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                observingF = true
            }
        }else{
            //ログインしていない場合//
            if observingF == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                postArray = []
                tableView.reloadData()
                // オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                // DatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observingF = false
            }

        }
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
