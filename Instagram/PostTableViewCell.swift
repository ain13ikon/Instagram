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
    @IBOutlet weak var commentField: UITextField!
    
    
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
        print("デバッグ：　setPostData()しています")

        //画像
        self.postImageView.image = postData.image
        
        //キャプション
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        //日付
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        //いいねの数
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねの画像をセット
        if postData.isLiked {
            //いいねされている場合
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        }else{
            //いいねされていない場合
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        //コメント
        //print(postData.comments)
        
    }

    
}




























