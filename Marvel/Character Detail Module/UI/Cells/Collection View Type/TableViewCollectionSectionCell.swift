//
//  TableViewCollectionSectionCell.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/4/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import UIKit



class TableViewCollectionSectionCell: UITableViewCell {

    
    static let identifier = "TableViewCollectionSectionCell"
    
    
    private var numberOfItems :Int {
        
        return cellsViewModels.count
    }
    
    
    var cellDidSelected : ( (_ _section:Int,_ _index:Int) -> (Void) )?
    
    
    var isVisitedForNetworkCall = [Int:Bool]()
    var getImageForCell : ( (_ _section:Int,_ _index:Int) -> (Void) )?
    
    
    private var sectionNumber = 0
    private var cellsViewModels :[MovieViewModelCell] = []
    
    
    private let collectionView :UICollectionView = {
        
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.register(CharacterMovieCell.self, forCellWithReuseIdentifier: CharacterMovieCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
        
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupCellUI()
        
       
        
       
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    /// Configure Cell and Load collection view Data
    ///
    /// - Parameters:
    ///   - tableSectionNumber: section number of this cell
    ///   - data: to be loaded in collectionView
    func configureData(tableSectionNumber:Int,data:[MovieViewModelCell]) {
        
        self.sectionNumber = tableSectionNumber
        self.cellsViewModels = data
        
        collectionView.reloadData()
        
    }
   
    func loadImageForCell(index:Int,url:String?) {
        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            guard let cell = strongSelf.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CharacterMovieCell else { return }
            
            
            strongSelf.cellsViewModels[index].thumbnailURL = url
            
            guard let url = url else { print("URL is nil");return }
            
            print("URL:\(url)")
            cell.loadImage(url:url)
            
        }
       
        
        
    }
    
  
}

//MARK: Setup UI
extension TableViewCollectionSectionCell {
    
    fileprivate func setupCollectionViewConstraints() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
            ])
    }
    
    fileprivate func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func setupCellUI() {
        self.backgroundColor = .clear
        setupCollectionViewConstraints()
        
        configureCollectionView()
    }
    
    
    
}
//MARK: Collection View Delegate Methods
extension TableViewCollectionSectionCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterMovieCell.identifier, for: indexPath) as? CharacterMovieCell else {print("CV Cell is nil"); return UICollectionViewCell() }
        
        if indexPath.item < numberOfItems  {
            
            
            let cellModel = cellsViewModels[indexPath.item]
            
            cell.configureData(name: cellModel.movieName, imageURL: cellModel.thumbnailURL)
            
            if let thumbnailURL =  cellModel.thumbnailURL {
                
                cell.loadImage(url: thumbnailURL)
                
            }else if isVisitedForNetworkCall[indexPath.item] == nil{
                
                isVisitedForNetworkCall[indexPath.item] = true
                getImageForCell?(sectionNumber,indexPath.item)
                
            }
            
        }
       
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        guard cell is CharacterMovieCell else { return }
//        
//        getImageForCell?(sectionNumber,indexPath.item)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width * 0.3
        return CGSize(width: width , height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(#function)")
        
        print("Cell [\(sectionNumber),\(indexPath.item)] is selected")
        cellDidSelected?(sectionNumber,indexPath.item)
    }
    
   
    
}
