//
//  CommentCell.swift
//  Instagram
//
//  Created by きたむら on 2018/09/20.
//  Copyright © 2018年 ain13ikon. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    
    func setComment(_ commentDic: [String: String]){
        let comment = commentDic["comment"]!
        let commenter = commentDic["commenter"]!
        commentLabel.text = comment + "\t（from:" + commenter + "）"
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
