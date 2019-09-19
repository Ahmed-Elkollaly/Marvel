//
//  MarvelCharacterCell.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/3/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import UIKit

class MarvelCharacterCell: UICollectionViewCell {

    static let identifier = "MarvelCharacterCell"
    
    @IBOutlet weak var bgLabelImageView: UIImageView!
    
    @IBOutlet weak var characterImageView: CachedImageView!
    
    @IBOutlet weak var characterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(characterName:String,thumbnailURL:String?){
        
        characterNameLabel.text = characterName
        
        
        
        if let url = thumbnailURL {
            characterImageView.loadImage(urlString: url)
        }
        
        
    }
    
    
}
