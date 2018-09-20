//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by きたむら on 2018/09/18.
//  Copyright © 2018年 ain13ikon. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentLabel: UILabel!
    
    //コメントテーブルビューの作成
    func setPostCellData(_ postDataComment: [String: String]){
        print("デバッグ：　コメントセルを作成")
        self.commentLabel.text = postDataComment["comment"]! + "\t（from: " + postDataComment["commenter"]! + "）"
        print(self.commentLabel.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
