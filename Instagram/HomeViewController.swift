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
    
    //表示するデータ(PostDataクラス)を配列で保持
    var postArray: [PostData] = []

    //DatabaseのobserveEventの登録状態を表す
    var observingF = false
    
    //セクションの数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return postArray.count
    }
    
    //Sectioのタイトル
    //余白用に使っている
    //課題：セクションのレイアウトで間隔を調整出来ないか
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    

    //セクションに表示するセル数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("デバッグ：　写真セル\(section)：コメント数\( postArray[section].comments.count)")
        print("デバッグ：　\(postArray[section].comments.count + 1)個しますのセルを作成")
        return postArray[section].comments.count + 1
            //コメント数＋１（写真セル）
    }
    
    //表示するセルの設定をする
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //indexPath.sectionでセクションの番数
        //indexPath.rowでセルの番数   を得られる
        
        //初めのセルは写真、以降のセルはコメント。（次の写真は次のセクションの初めのセルになる）
        if indexPath.row == 0 {
            //写真セルを作成
            print("デバッグ：　写真セルを作成します")
            print("デバッグ：　写真セル\(indexPath.section)個目")
            // PostTableViewCellで作成しているセルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
            cell.setPostData(postArray[indexPath.section])  //セルの中身を作成
            
            // いいねボタンのアクションをソースコードで設定する
            cell.likeButton.addTarget(self, action:#selector(handleLikeButton(_:forEvent:)), for: .touchUpInside)
            
            //コメントボタンのアクションをソースコードで設定する
            cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_: forEvent:)), for: .touchUpInside)
            
            print("デバッグ：　この投稿に対するコメントは\(postArray[indexPath.section].comments.count)件")
            
            return cell

        }else{
            //コメントセルを作成
            print("デバッグ：　コメントセルを設定します")
            print("デバッグ：　\(indexPath.row - 1)個目のコメントをセルを作成します")
            // CommentCellで作成しているセルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! CommentCell
            cell.setComment(postArray[indexPath.section].comments[indexPath.row - 1])
                //コメントセルの中身を作成 初めのセルは写真なのでindexPathから-1する
            
            return cell
        }
        
    }
    
    //コメントボタンがタップされた時に呼ばれるメソッド
    @objc func handleCommentButton(_ sender: UIButton, forEvent event: UIEvent){
        print("DEBUG_PRINT: コメントボタンがタップされました。")
        //ログイン状態をチェック
        if let user = Auth.auth().currentUser {
            // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: point)
            
            // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath!.section]
            
            //*コメント内容を取得する
            //タップされたボタンのセルのインデックスからCellを取り出す
            if let cell = tableView.cellForRow(at: indexPath!) as? PostTableViewCell{
                if let commentKari = cell.commentField.text {
                    if commentKari != "" {
                        print("デバッグ：　コメントが入力されています")
                        let comment = commentKari
                        
                        //コメント者を取得する
                        let commenter = user.displayName!
                        print("デバッグ：　\(comment) by\(commenter)")
                        
                        //*コメントをデータベースに保存する
                        //**投稿データの保存場所を取得する
                        let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
                        //**投稿データのコメントに追加する
                        let newComment = ["comment": comment, "commenter": commenter]
                        postData.comments.insert(newComment, at: 0)
                        //**投稿データをアップデートする
                        postRef.updateChildValues(["comments": postData.comments])
                        print("デバッグ：　コメント：\(postData.comments)")

                    }else{
                        print("デバッグ：　コメントが入力されていません")
                    }
                }
                //入力欄をデフォルトに戻す
                cell.commentField.text = ""
                cell.commentField.placeholder = "コメントを追加"
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
        
        print("デバッグ：　\(indexPath!.section)のデータ")
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.section]
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if postData.isLiked {
                //いいねをしていた場合//
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1  //for inで該当データがなかった場合にremoveしないため、０・整数以外の値を初期値にしておく。
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
        
        //テーブルビュー：写真用セルの内容を取得
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        //テーブルビュー：コメント用セルの内容を取得
        let nib2 = UINib(nibName: "CommentCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "Cell2")

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
                        print("デバッグ：　テーブルビューをリロードします")
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
                        print("デバッグ：　テーブルビューをリロードします")
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
