//
//  SearchMarvelCharacterViewModel.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/6/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation


protocol SearchMarvelCharacterViewModelDelegate {
    
    func filterdCharactersDidFetched()
    
}

class SearchMarvelCharactersViewModel {
    
    
    var  searchDelegate : SearchMarvelCharacterViewModelDelegate?
    
    var numberOfCells :Int {
        
        return marvelCharactersCells.count
    }
    
    
    private var marvelCharacters :[MarvelCharacter] = []
    private var marvelCharactersCells :[CharacterViewModelCell] = [] {
        
        didSet {
            
            searchDelegate?.filterdCharactersDidFetched()
        }
    }
    
    private let remoteCharacterRepository :RemoteCharacterRepository
    private let localCharacterRepository :LocalCharacterRepository
    
    init() {
    
        remoteCharacterRepository = RemoteCharacterRepository(endPoint: MarvelApiEndPoint.filterCharacters(nameStartsWith: ""))
    
         localCharacterRepository = LocalCharacterRepository()
    }
    func getCharacter(at index: Int) -> MarvelCharacter? {
        
        guard index >= 0 && index < marvelCharacters.count else { return nil }
        
        return marvelCharacters[index]
        
    }
    func getCellViewModel(at index:Int) -> CharacterViewModelCell? {
        
        
        guard index >= 0 && index < marvelCharactersCells.count else { return nil }
        
        return marvelCharactersCells[index]
        
    }
    func getFilteredMarvelCharacters(withNameStartsWith name:String ) {
        
        remoteCharacterRepository.getCharacters(withNameStartsWith: name) { [weak self] characters in
            
            guard let strongSelf = self else { return }
            
            strongSelf.marvelCharacters = characters
            strongSelf.marvelCharactersCells = characters.map {
                
                character in
                
                return CharacterViewModelCell(characterName:character.name,thumbnailURL:character.thumbnail?.fullPath)
            }
            
            
        }
        
        
    }
    func removeResults(){
        
        marvelCharacters.removeAll()
        marvelCharactersCells.removeAll()
    }
}
