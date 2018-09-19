//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by きたむら on 2018/09/18.
//  Copyright © 2018年 ain13ikon. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var commentLabel: UITextField!
    
    var postDatacomments: [[String: String]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //投稿データをセットする
    func setPostData(_ postData: PostData){
        print("デバッグ：　setPostData()します")
        /*
        print("途中：　postDatacommentsのデータは仮です")
        //self.postDatacomments = postData.comments
        self.postDatacomments = [
            ["name": "花子",  "comment": "コメント１"],
            ["name": "太郎",  "comment": "コメント２"]
        ]
         */
        //画像
        self.postImageView.image = postData.image
        
        //キャプション
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        //いいね
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //日付
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            //いいねされている場合
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        }else{
            //いいねされていない場合
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        /*
        //コメントラベルにidentifierを設定
        let commentIdentifier = "comment" + postData.id!
        self.commentLabel.accessibilityIdentifier = commentIdentifier
        */
        
        /*
        //コメントの表示内容を指定する//
        //複数人のコメント→新たにテーブルビューを作って実装
        //コメント＆投稿者で一つのセル
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        //テーブルセルのタップを無効にする
        commentTableView.allowsSelection = false
        
        //テーブルビューの内容を取得
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        commentTableView.register(nib, forCellReuseIdentifier: "CommentCell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        commentTableView.rowHeight = UITableViewAutomaticDimension
        // テーブル行の高さの概算値を設定しておく
        // 高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        commentTableView.estimatedRowHeight = 100
        
        //self.commentTableView.reloadData()
        */
    }
    
    /*
    //コメントテーブルビューのセル数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("コメントは\(postDatacomments.count)件です")
        return postDatacomments.count
    }
    //コメントテーブルビューのセル設定を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("デバッグ：　コメントテーブルビュー")
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        print("デバッグ：　setPostCellData()します")
        cell.setPostCellData(postDatacomments[indexPath.row])
        
        return cell
    }
    */
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        //テーブルセルのタップを無効にする
        commentTableView.allowsSelection = false
        
        //テーブルビューの内容を取得
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        commentTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        commentTableView.rowHeight = UITableViewAutomaticDimension
        // テーブル行の高さの概算値を設定しておく
        // 高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        commentTableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        
    }
    */
    
}




























