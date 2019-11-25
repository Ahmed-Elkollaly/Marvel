//
//  MarvelCharactersVC.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/3/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import UIKit
import AudioToolbox

class MarvelCharactersVC: UIViewController {

    
    //MARK: Properties
    lazy var searchCharacterVC: SearchMarvelCharacterVC = {
        
        let vc = SearchMarvelCharacterVC()
        vc.view.isHidden = true
        self.addViewControllerAsChildViewController(childViewController: vc)
        return vc
        
        
    }()
    lazy var refreshControl : UIRefreshControl = {
       
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(self.referesh(_:)), for: UIControl.Event.valueChanged)
        
        return control
        
    }()
    lazy var marvelCharactersCollectionView : UICollectionView = {
    
        let layout = UICollectionViewFlowLayout()
        layout.itemSize  = CGSize(width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: self.view.safeAreaLayoutGuide.layoutFrame.height * 0.25)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        
        let safeFrame = self.view.safeAreaLayoutGuide.layoutFrame
        let collectioVeiwFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY, width: safeFrame.width, height: self.view.frame.height - safeFrame.minY)
        
        let cv = UICollectionView(frame: collectioVeiwFrame, collectionViewLayout: layout)
        
        let nib = UINib(nibName: MarvelCharacterCell.identifier, bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: MarvelCharacterCell.identifier)
        
        cv.delegate = self
        cv.dataSource = self
        
    
        return cv
    }()
    
   
    
    private let marvelCharacterViewModel = MarvelCharactersViewModel()

    //MARK: App Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        
        
        marvelCharacterViewModel.charactersDelegate = self
        setupUI()
        searchCharacterVC.searchBarDelegate = self
            
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavControllerUI()
    }
    
    // MARK: Actions
    
    @objc func referesh(_ sender: UIRefreshControl){
        
        
        print("Referesh!!")
        
        if !sender.isSelected {
            
            sender.isSelected = true
            marvelCharacterViewModel.loadNextPage()
            
        }
    }
    @objc func search(_ sender: UITapGestureRecognizer){
        
//        print("Search!")
        AudioServicesPlaySystemSound(1520)
        let isSearchCharacterVCHidden = searchCharacterVC.view.isHidden
        
        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            if isSearchCharacterVCHidden {
                
                
                
                
                
                strongSelf.navigationItem.titleView = strongSelf.searchCharacterVC.searchController.searchBar
                
                
//                strongSelf.navigationItem.rightBarButtonItem = nil
                
                let rightBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(strongSelf.search(_:)))
                strongSelf.navigationItem.setRightBarButton(rightBarItem, animated: false)
                
                
            }else {
                strongSelf.setupNavControllerUI()
            }
            
            strongSelf.searchCharacterVC.view.isHidden = !isSearchCharacterVCHidden
            
            
            
            
        }
        
        
        
        
    }
   

}
//MARK:- Setup UI
extension MarvelCharactersVC {
    
    func addViewControllerAsChildViewController(childViewController: UIViewController) {
        addChild(childViewController)
        
        setupChildViewControllerView(childView: childViewController.view)
        childViewController.didMove(toParent: self)
        
        
    }
    func setupChildViewControllerView(childView:UIView){
        
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: guide.topAnchor),
            childView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            
            childView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
            ])
        
        childView.clipsToBounds = true
        
        
    }
    func setupUI(){
        
        self.marvelCharactersCollectionView.addSubview(refreshControl)
        
        self.view.addSubview(marvelCharactersCollectionView)
    
        
    }
    func setupNavControllerUI(){
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(false, animated: false)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
            navController.navigationBar.backgroundColor = .white
            navController.navigationBar.barTintColor = .black
            navController.navigationBar.tintColor = .red
            navController.navigationBar.barStyle = .black
            navController.navigationBar.isTranslucent = false
            

            
            
            if let logo = UIImage(named: "icn-nav-marvel") {
               let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 62, height: 28))
                logoImageView.image = logo
                self.navigationItem.titleView = logoImageView
               
            }
            if let searchIcon = UIImage(named:"icn-nav-search") {
               
                
                let searchImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
                searchImageView.image = searchIcon
                
                //enable user interaction for search image view
                searchImageView.isUserInteractionEnabled = true
                
                
                //add tap gesture to search image view
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.search(_:)))
                searchImageView.addGestureRecognizer(tapGesture)
                
                let rightBarItem = UIBarButtonItem(customView: searchImageView)
                
                
                self.navigationItem.setRightBarButton(rightBarItem, animated: false)
            }
            
            
            
        }
    }
    
    
}
extension MarvelCharactersVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return marvelCharacterViewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelCharacterCell.identifier, for: indexPath) as? MarvelCharacterCell else { return UICollectionViewCell() }
        
        if let cellViewModel = marvelCharacterViewModel.getCellViewModel(at: indexPath.item) {
            
            async_main {
                
                [weak cell] in
                
                guard let cell = cell else { return }
             
                cell.configure(characterName: cellViewModel.characterName, thumbnailURL: cellViewModel.thumbnailURL)
            }
            
            
        }
        
        
        
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if let marvelCharacter = marvelCharacterViewModel.getCharacter(at: indexPath.item) {
            
            
            let characterDetailViewModel = CharacterDetailViewModel(marvelCharacter: marvelCharacter)
            
            let characterDetailVC = CharacterDetailVC(marvelCharacterDetailViewModel: characterDetailViewModel)
            
            characterDetailViewModel.delegate = characterDetailVC
            
            characterDetailVC.modalPresentationStyle = .overFullScreen
            present(characterDetailVC, animated: false, completion: nil)
            
            
        }
        
        
    }
    
    
}

extension MarvelCharactersVC :MarvelCharactersDelegate {
    func charactersDidFetched() {
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.marvelCharactersCollectionView.reloadData()
            
        }
    }
    func nextPageDidLoaded(newOffset: Int) {
        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            
            
            
//            let insertions = Array(newOffset ..< strongSelf.marvelCharacterViewModel.numberOfCells)
//            strongSelf.marvelCharactersCollectionView.applyChanges(deletions: [], insertions: insertions, updates: [])
            
            strongSelf.marvelCharactersCollectionView.reloadData()
            
            strongSelf.refreshControl.isSelected = false
            strongSelf.refreshControl.endRefreshing()
            
        }
        
    }
    
    
    
}

//MARK: Search Bar Delegate Method

extension MarvelCharactersVC : SearchMarvelCharacterVCDelegate {
    
    
    func cancelSearchBarButtonDidSelected() {
        
        AudioServicesPlaySystemSound(1520)
        let isSearchCharacterVCHidden = searchCharacterVC.view.isHidden
        
        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            if isSearchCharacterVCHidden {
                
                
                
                
                
                strongSelf.navigationItem.titleView = strongSelf.searchCharacterVC.searchController.searchBar
                
                
                strongSelf.navigationItem.rightBarButtonItem = nil
                
                //                let rightBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(strongSelf.search(_:)))
                //                strongSelf.navigationItem.setRightBarButton(rightBarItem, animated: false)
                
                
            }else {
                strongSelf.setupNavControllerUI()
            }
            
            strongSelf.searchCharacterVC.view.isHidden = !isSearchCharacterVCHidden
        
    }
    
    }
    
    
    
}
