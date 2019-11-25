//
//  RemoteCharacterRepository.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/3/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation



class RemoteCharacterRepository {
    
    
    
    private let marvelService :MarvelNetworkService
    
    
    
    init(endPoint:MarvelApiEndPoint){
        
        self.marvelService = MarvelNetworkService(endPoint: endPoint)
        
    }
    
    
    
    func decodeDataToMarvelCharacters(data:Data) -> [MarvelCharacter]  {
        
        
        do {
            
            let marvelResponse = try JSONDecoder().decode(MarvelCharacterResponse.self, from: data)
    
            return marvelResponse.data.results
            
        }catch {
            
            print("Can't Decode Response to Object")
            
            
        }
        
        
        return []
    }
    func decodeDataToThumbnailForMovie(data:Data) -> Thumbnail? {
        
        
        do {
            
            let movieResponse = try JSONDecoder().decode(MarvelMovieResponse.self, from: data)
            
            let isFirstThumbnailExist = movieResponse.data.results.count > 0
            
            return isFirstThumbnailExist ? movieResponse.data.results[0].thumbnail : nil
            
        }catch {
            
            print("Can't Decode Response to Thumbnail")
            
        }
        
        return nil
    }
    func loadCharacters(limit:Int = 10, page:Int = 0,_ completionHandler: @escaping (([MarvelCharacter]) -> Void)){
        
        let offset = page < 0 ? 0 : page * limit
        
        self.marvelService.endPoint = MarvelApiEndPoint.allConstrainted(limit: limit, offset: offset)
        
        getAll { (marvelCharacters) in
            
            completionHandler(marvelCharacters)
        
        }
        
    }
    func loadMovieThumbnailUrl(resourceURL :String,_ completionHandler: @escaping ((Thumbnail?) -> Void))  {
        
        
        
        
        let endPoint = MarvelApiEndPoint.movieResourceURL(resourceURL: resourceURL)
        
        self.marvelService.endPoint = endPoint
        
        self.marvelService.fetchData { [weak self] response, data in
            
            
            guard let strongSelf = self else  { return }
            
           
            guard let data = data else { return completionHandler(nil) }
            
            
            completionHandler(strongSelf.decodeDataToThumbnailForMovie(data: data))
            
        }
    }
    
   
    
}
extension RemoteCharacterRepository : Respository {
    
    func getAll(_ completionHandler: @escaping (([MarvelCharacter]) -> Void)) {
        
        self.marvelService.fetchData { [weak self] response, data in
            
            
            guard let strongSelf = self else  { print("\(#function): self is nil"); return }
            
            guard let data = data else { print("\(#function): Data is nil");return completionHandler([]) }
            
            
            completionHandler(strongSelf.decodeDataToMarvelCharacters(data: data))
            
        }
        
    }
    func getCharacters(withNameStartsWith name: String, _ completionHandler: @escaping (([MarvelCharacter]) -> Void)) {
        
        self.marvelService.endPoint = MarvelApiEndPoint.filterCharacters(nameStartsWith: name)
        
        self.marvelService.fetchData { [weak self] response, data in
            
            
            guard let strongSelf = self else  { return }
            
            guard let data = data else { return completionHandler([]) }
            
            
            completionHandler(strongSelf.decodeDataToMarvelCharacters(data: data))
            
        }
        
        
    }
    
}
