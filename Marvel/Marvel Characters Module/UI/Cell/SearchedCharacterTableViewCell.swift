//
//  SearchedCharacterTableViewCell.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/6/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import UIKit

class SearchedCharacterTableViewCell: UITableViewCell {

    
    static let identifier = "SearchedCharacterTableViewCell"
    @IBOutlet weak var characterImageView: CachedImageView!
    
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
