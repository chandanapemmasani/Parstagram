//
//  PostCell.swift
//  Parstagram
//
//  Created by Chandana Pemmasani on 10/6/21.
//

import UIKit

class PostCell: UITableViewCell {

    
    
    @IBOutlet weak var feedPhotoview: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var captionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
