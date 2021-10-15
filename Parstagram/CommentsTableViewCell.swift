//
//  CommentsTableViewCell.swift
//  Parstagram
//
//  Created by Chandana Pemmasani on 10/13/21.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentName: UILabel!
    
    @IBOutlet weak var commentContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
