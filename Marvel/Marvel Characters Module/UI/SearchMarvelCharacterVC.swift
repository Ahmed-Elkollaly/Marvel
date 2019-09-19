//
//  SearchMarvelCharacterVC.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/6/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import UIKit


protocol SearchMarvelCharacterVCDelegate {
    func cancelSearchBarButtonDidSelected()
}
class SearchMarvelCharacterVC: UIViewController {

    
     lazy var searchController : CustomSearchController = {
       
        let searchVC = CustomSearchController(searchResultsController: nil)
        searchVC.searchBar.delegate = self
        searchVC.dimsBackgroundDuringPresentation = false
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.searchBar.placeholder = "Search... "
        searchVC.searchBar.showsCancelButton = false
        
        definesPresentationContext = true
        searchVC.view.backgroundColor = .clear
     
        
        return searchVC
    }()
    private lazy var resultsTableView :UITableView = {
        
        let table = UITableView(frame: self.view.bounds)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .gray
        table.rowHeight = 60
        let nib = UINib(nibName: SearchedCharacterTableViewCell.identifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: SearchedCharacterTableViewCell.identifier)
        table.separatorStyle = .none
        self.view.addSubview(table)
        
        return table
    }()
    private let searchCharacterViewModel = SearchMarvelCharactersViewModel()
    private var previousRun = Date()
    private let minInterval = 0.05
    
    
    var searchBarDelegate :SearchMarvelCharacterVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .darkGray
        searchCharacterViewModel.searchDelegate = self
        
        
        
    }
    

  

}
//MARK: Search Bar Delegate Methods
extension SearchMarvelCharacterVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCharacterViewModel.removeResults()
        
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
    
    func fetchResults(for text: String) {
   
        
    searchCharacterViewModel.getFilteredMarvelCharacters(withNameStartsWith: text)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchCharacterViewModel.removeResults()
        searchBarDelegate?.cancelSearchBarButtonDidSelected()
        
    }
    
}
//MARK: Table View Delegate Methods

extension SearchMarvelCharacterVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCharacterViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedCharacterTableViewCell.identifier , for: indexPath) as? SearchedCharacterTableViewCell else  { return UITableViewCell() }
        
        if let cellModel = searchCharacterViewModel.getCellViewModel(at: indexPath.item) {
            
        
            async_main {
                
                cell.characterName.text = cellModel.characterName
                cell.selectionStyle = .none
                if let thumbnailURL = cellModel.thumbnailURL  {
                    
                    
                    cell.characterImageView.loadImage(urlString: thumbnailURL)
                }
                
                
            }
            
            
            
        
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let marvelCharacter = searchCharacterViewModel.getCharacter(at: indexPath.item) {
            
            
            let characterDetailViewModel = CharacterDetailViewModel(marvelCharacter: marvelCharacter)
            
            let characterDetailVC = CharacterDetailVC(marvelCharacterDetailViewModel: characterDetailViewModel)
            
            characterDetailViewModel.delegate = characterDetailVC
            
            characterDetailVC.modalPresentationStyle = .overFullScreen
            present(characterDetailVC, animated: false, completion: nil)
            
            
        }
    }
    
    
    
    
}
//MARK: Search Delegate
extension SearchMarvelCharacterVC :SearchMarvelCharacterViewModelDelegate {
    func filterdCharactersDidFetched() {
        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            
            strongSelf.resultsTableView.reloadData()
            
        }
        
        
    }
    
    
    
    
    
}
