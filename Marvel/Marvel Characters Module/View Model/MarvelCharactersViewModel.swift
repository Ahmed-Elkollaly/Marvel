//
//  MarvelCharactersViewModel.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/3/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation


/// Delegate protocol used by "MarvelCharactersViewModel" to trigger the completion of data fetching
protocol MarvelCharactersDelegate {
    
    func charactersDidFetched()
    func nextPageDidLoaded(newOffset:Int)
}

/// ViewModel class for "MarvelCharactersVC"
class MarvelCharactersViewModel {
    
    
    
    
    var charactersDelegate :MarvelCharactersDelegate?
    
    
    
    var numberOfCells :Int {
        
        return marvelCharactersCells.count
    }
    
    
    private var pageNo = 0
    private let limit = 20
    
    private var marvelCharacters :[MarvelCharacter] = []
    private var marvelCharactersCells :[CharacterViewModelCell] = []
    
    private let remoteCharacterRepository :RemoteCharacterRepository
    private let localCharacterRepository :LocalCharacterRepository
    
    init() {
        
        remoteCharacterRepository = RemoteCharacterRepository(endPoint: MarvelApiEndPoint.allConstrainted(limit: 10, offset: 0))
        localCharacterRepository = LocalCharacterRepository()
        
        remoteCharacterRepository.getAll { [weak self] characters in
            
            guard let strongSelf = self else { return }
            
            strongSelf.marvelCharacters = characters
            strongSelf.marvelCharactersCells = characters.map {
                
                character in
                
                return CharacterViewModelCell(characterName:character.name,thumbnailURL:character.thumbnail?.fullPath)
            }
            
            strongSelf.charactersDelegate?.charactersDidFetched()
            
        }
        
    }
    func getCharacter(at index: Int) -> MarvelCharacter? {
        
        guard index >= 0 && index < marvelCharacters.count else { return nil }
        
        return marvelCharacters[index]
        
    }
    func getCellViewModel(at index:Int) -> CharacterViewModelCell? {
        
        
        guard index >= 0 && index < marvelCharactersCells.count else { return nil }
        
        return marvelCharactersCells[index]
    
    }
    func loadNextPage(){
        pageNo += 1
        
        remoteCharacterRepository.loadCharacters(limit:limit,page: pageNo) { [weak self] (characters) in
            
            
            guard let strongSelf = self else { return }
            
            strongSelf.marvelCharacters.append(contentsOf: characters)
            let newCellModels = characters.map {
                
                character in
                
                return CharacterViewModelCell(characterName:character.name,thumbnailURL:character.thumbnail?.fullPath)
            }
            
            strongSelf.marvelCharactersCells.append(contentsOf: newCellModels)
            
            strongSelf.charactersDelegate?.nextPageDidLoaded(newOffset:strongSelf.limit * strongSelf.pageNo)
            
        }
    }
    
    
}

