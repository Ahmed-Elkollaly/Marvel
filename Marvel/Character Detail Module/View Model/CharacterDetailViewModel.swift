//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/5/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation


protocol CharacterDetailViewModelDelegate {
    
    func thumbnailURlDidFetched(forSection:Int, index:Int,url:String?)
}
class CharacterDetailViewModel {
    
    
    
    private enum CateogorySection : Int, CaseIterable {
        
        case comics = 0 , series,stories,events,relatedLinks
        
        var name :String {
            switch self {
            case .comics:
                return "COMICS"
            case .series:
                return "SERIES"
            case .stories:
                return "STORIES"
            case .events:
                return "EVENTS"
            case .relatedLinks:
                return "RELATED LINKS"
            }
        }
        
        
        
        
    }
    
    var delegate :CharacterDetailViewModelDelegate?
    var numberOfRowsOfContainerTableView : Int {
        return 1
    }
    var numberOfSectionsOfContainerTableView : Int {
        
        
        return CateogorySection.allCases.count
        
    }
    
    var imageViewURL :String? {
        
        
        return marvelCharacter.thumbnail?.fullPath
    }
    var characterName :String {
        
        
        return marvelCharacter.name
    }
    
    var bio : String {
        
        return marvelCharacter.desc
    }
    
    
    
    private lazy var comicsViewModelCells :[MovieViewModelCell] = {
        
        
        guard let comics = marvelCharacter.comics else { return [] }
        
        return Array(comics.items).map {  comic in
            
            MovieViewModelCell(movieName:comic.name, thumbnailURL: nil)
        }
        
    }()
    
    private lazy var seriesViewModelCells :[MovieViewModelCell] = {
        
        guard let series = marvelCharacter.series else { return [] }
        
        return Array(series.items).map {  series in
            
            MovieViewModelCell(movieName:series.name, thumbnailURL: nil)
        }
        
    }()
    
    private lazy var storiesViewModelCells :[MovieViewModelCell]  = {
        
        guard let stories = marvelCharacter.stories else { return [] }

        
        return Array(stories.items).map {
            story in
            
            MovieViewModelCell(movieName:story.name, thumbnailURL: nil)
            
        }
    }()
    
    private lazy var eventsViewModelCells :[MovieViewModelCell] = {
        
        guard let events = marvelCharacter.events else { return [] }
        
        
        return Array(events.items).map {
            event in
            
            MovieViewModelCell(movieName:event.name, thumbnailURL: nil)
            
        }
        
    }()
    
    
    private var relatedLinksViewModelCells :[LinkViewModelCell]  {
        
        return marvelCharacter.urls.map {
            link in
            
            LinkViewModelCell.init(type: link.type, url: link.url)
            
            
        }
        
    }
    
    
    
    private let marvelCharacter :MarvelCharacter
    private let remoteCharacterRepository :RemoteCharacterRepository
    private let localCharacterRepository :LocalCharacterRepository
    
    init(marvelCharacter:MarvelCharacter) {
        
        self.marvelCharacter = marvelCharacter
        
        remoteCharacterRepository = RemoteCharacterRepository(endPoint: MarvelApiEndPoint.movieResourceURL(resourceURL: nil))
        localCharacterRepository = LocalCharacterRepository()
        
    }
    
    func getSectionHeader(section:Int) -> String? {
        
        
        guard let cateogory = CateogorySection(rawValue: section) else { return nil }
        
        return cateogory.name
        
    }
    
    func isSectionIsRelatedLinksTableViewSection(section index: Int) -> Bool {
        
        guard let cateogory = CateogorySection(rawValue: index) else { return false }
        
        
        return cateogory == .relatedLinks
        
    }
    
    func getRelatedLinkViewModels() -> [LinkViewModelCell] {
        
        return relatedLinksViewModelCells
    }
    
    
    func getSectionCellsViewModels(section index:Int) -> [MovieViewModelCell]? {
        
        guard let cateogory = CateogorySection(rawValue: index) else { return nil }
        
        
        switch cateogory {
        
            
        
        case .comics:
            
            return comicsViewModelCells
            
        case .series:
            
            return seriesViewModelCells
            
        case .stories:
            
            return storiesViewModelCells
            
        case .events:
            
            return eventsViewModelCells
            
        case .relatedLinks:
            
            return nil
            
        }
        
        
        
        
    }
    
    
    func getResourceURL(section :Int,index :Int) -> String? {
        
        guard let cateogry = CateogorySection(rawValue: section) else { return nil }
        
        
        switch cateogry {
       
        
        case .comics:
           
            return getComicResourceURL(index: index)
            
        case .series:
            return getSeriesResourceURL(index: index)
        case .stories:
            return getSeriesResourceURL(index: index)
        case .events:
            return getEventResourceURL(index: index)
        case .relatedLinks:
            return nil
        }
        
    }
    private func getComicResourceURL(index:Int) -> String? {
        
        guard let comics = marvelCharacter.comics else { return nil }
        
        let count = comics.items.count
        
        guard index < count && index >= 0 else { return nil }
        
        return comics.items[index].resourceURI
        
    }
    private func getStoryResourceURL(index:Int) -> String? {
        
        guard let stories = marvelCharacter.stories else { return nil }
        
        let count = stories.items.count
        
        guard index < count && index >= 0 else { return nil }
        
        return stories.items[index].resourceURI
        
    }
    private func getEventResourceURL(index:Int) -> String? {
        
        guard let events = marvelCharacter.events else { return nil }
        
        let count = events.items.count
        
        guard index < count && index >= 0 else { return nil }
        
        return events.items[index].resourceURI
        
    }
    private func getSeriesResourceURL(index:Int) -> String? {
        
        guard let series = marvelCharacter.series else { return nil }
        
        let count = series.items.count
        
        guard index < count && index >= 0 else { return nil }
        
        return series.items[index].resourceURI
        
    }
    
    
    func fetchMovieThumbnailURL(section :Int,index :Int){
        
        
        guard let resourceURL = getResourceURL(section: section, index: index) else { print("resource URL is nil"); return}
        
        
        remoteCharacterRepository.loadMovieThumbnailUrl(resourceURL: resourceURL) { [weak self] thumbnail in
                
            guard let strongSelf = self else { return }
            
            
          
            
            
            strongSelf.delegate?.thumbnailURlDidFetched(forSection: section, index: index, url: thumbnail?.fullPath)
                
        }
        
        
        
        
        
        
    }
}
