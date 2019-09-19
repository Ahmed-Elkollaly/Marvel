//
//  CharacterMovieCell.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/4/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import UIKit

class CharacterMovieCell: UICollectionViewCell {
    
    static let identifier = "CharacterMovieCell"
    
    private let movieImageView : CachedImageView = {
        
        let imgView = CachedImageView(frame: CGRect.zero)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .black
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
        
    }()
    
    private let movieName : UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hero"
        label.textAlignment = .center
        
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupCellUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureData(name:String,imageURL:String?){
        
        async_main {
            
            [weak self] in

            guard let strongSelf = self else { return }
            
            strongSelf.movieName.text = name
            
            guard let imageURL = imageURL else { return }
            
            strongSelf.movieImageView.loadImage(urlString: imageURL)
            
            
        }
        
        
    }
    func loadImage(url:String) {
        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.movieImageView.loadImage(urlString: url)
            
            
            
        }
        
        
    }
   
}

//MARK: Setup UI
extension CharacterMovieCell {
    fileprivate func setupImageViewUIContraints() {
        addSubview(movieImageView)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: self.topAnchor,constant:5),
            movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:5),
            movieImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant:-5),
            movieImageView.heightAnchor.constraint(equalToConstant: self.frame.width * 1.25)
            
            ])
    }
    
    fileprivate func setupMovieNameLabelConstraints() {
        addSubview(movieName)
        NSLayoutConstraint.activate([
            movieName.topAnchor.constraint(equalTo: movieImageView.bottomAnchor,constant:5),
            movieName.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:5),
            movieName.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant:-5),
            movieName.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:-5)
            
            ])
    }
    
    fileprivate func setupCellUI() {
        setupImageViewUIContraints()
        
        setupMovieNameLabelConstraints()
    }
}
