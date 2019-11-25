//
//  MarvelCharactersService.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/2/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation

/// Define Marvel request endpoints structure and its parameters if exist
enum MarvelApiEndPoint : ApiEndPointProtocol {
    
    
    case allCharacters
    
    case allConstrainted(limit: Int,offset: Int)
    
    case character(characterId: Int)
    
    case filterCharacters(nameStartsWith:String)
    
    //Endpoint to get image for comic, event, series, story
    case movieResourceURL(resourceURL:String?)
    
    var baseURL: URL? {
        
        
        return URL(string: "https://gateway.marvel.com/v1/public/")
    }
    
    var path: String {
        switch self {
        case .allCharacters, .allConstrainted, .filterCharacters(_) :
            
            return "characters"
        
        case let .character(characterId):
            return "charachters/\(characterId)"
            
        
            
        case .movieResourceURL(let resourceURL):
        
            guard let resourceURL = resourceURL else { return "" }
            
            let baseURLStr = "http://gateway.marvel.com/v1/public/"
            return resourceURL.replacingOccurrences(of: baseURLStr , with: "")
            
            
        }
    }
    
    var method: HTTPMethod {
        
        return .get
    }
    
    
    var parameters :Parameters {
        
        var parameters = Parameters()
        
        switch self {
            
        case .allConstrainted(let limit,let offset) :
            
            parameters["offset"] = offset
            parameters["limit"] = limit
            
        case .filterCharacters(nameStartsWith: let name):
            parameters["nameStartsWith"] = name
            parameters["limit"] = 5
        default:
            break
        }
        
        parameters["ts"] = MarvelAuthentication.timeStamp
        parameters["apikey"] = MarvelAuthentication.publicKey
        parameters["hash"] = MarvelAuthentication.hashValue
        
        return parameters
        
    }
    
    
    
    
    
    
    
    
    
}

/// Defines Struct MarvelAuthentication for private and public API Keys and computed hashValue required for authentication
fileprivate struct MarvelAuthentication {
    
    
    static let publicKey = "5e0e99e03236e2174c5df378d9a679a3"
    
    static let timeStamp = String(Date().timeIntervalSinceReferenceDate)
    
    
    private static let privateKey = "8033fb689ae2b7116413bfc5fd14a39ecb650d2d"
    
    static var hashValue :String? {
        
        
        /// For authentication, marvel api use  rule ts+privateKey+publicKey then apply md5 hashing algorithm on it
        let str = MarvelAuthentication.timeStamp + privateKey + MarvelAuthentication.publicKey
        
        return str.md5()
        
        
    }
    
    
    
}
