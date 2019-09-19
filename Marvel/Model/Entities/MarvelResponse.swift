//
//  MarvelResponse.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/3/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

/// Define structure of Marvel API Response.
/// Check https://developer.marvel.com/docs#!/public/getCreatorCollection_get_0 for more info

struct MarvelCharacterResponse : Decodable {
    
    var code :Int
    var status :String
    var data : MarvelCharacterResponseData
    
    enum CodingKeys: String, CodingKey {
        case code
        case status
        case data
       
    }
    init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decode(Int.self, forKey: .code)
        status = try container.decode(String.self, forKey: .status)
        data = try container.decode(MarvelCharacterResponseData.self, forKey: .data)
    
    }
    
   
    
    
}

struct MarvelCharacterResponseData : Decodable {
    
    let offset :Int
    let limit : Int
    let total : Int
    let count : Int
    let results : [MarvelCharacter]
    
    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
        
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        offset = try container.decode(Int.self, forKey: .offset)
        limit = try container.decode(Int.self, forKey: .limit)
        total = try container.decode(Int.self, forKey: .total)
        count = try container.decode(Int.self, forKey: .count)

        results = try container.decode([MarvelCharacter].self, forKey: .results)
        
    }
    
    
}
/// MarvelCharachter inherit from "Object" for local presistance and from "Decodable" to decode response
@objcMembers class MarvelCharacter : Object, Decodable {
    
    dynamic var id : Int = 0
    dynamic var name : String = ""
    dynamic var desc :String = "" //A short bio or description of the character.
    dynamic var thumbnail :Thumbnail?
    
    let urls = List<Url>()
    
    dynamic var comics : ComicList?
    dynamic var stories : StoryList?
    dynamic var events : EventList?
    dynamic var series : SeriesList?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc = "description"
        case urls
        case thumbnail
        case comics
        case stories
        case events
        case series
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        desc = try container.decode(String.self, forKey: .desc)
     
        let urlsList = try container.decode([Url].self, forKey: .urls)
        urls.append(objectsIn: urlsList)
        
        thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
        
        comics = try container.decode(ComicList.self, forKey: .comics)
        stories = try container.decode(StoryList.self, forKey: .stories)
        events = try container.decode(EventList.self, forKey: .events)
        series = try container.decode(SeriesList.self, forKey: .series)
       
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
}
@objcMembers class Thumbnail : Object, Decodable {
    
    dynamic var path : String = ""
    dynamic var ext : String = ""
    
    
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        path = try container.decode(String.self, forKey: .path)
        ext = try container.decode(String.self, forKey: .ext)
        
        super.init()
    }
    
    var fullPath :String {
        return path + "." + ext
    }
    
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
}
@objcMembers class Url : Object, Decodable {

    dynamic var type : String = ""
    dynamic var url : String = ""
  
    
    
    enum CodingKeys: String, CodingKey {
        case type
        case url
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(String.self, forKey: .type)
        
        url = try container.decode(String.self, forKey: .url)
        
       
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

}

@objcMembers class ComicList : Object, Decodable {
    
    
   
    let items = List<ComicSummary>()
    
    
    enum CodingKeys: String, CodingKey {
        case items
        
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodeItems = try container.decode([ComicSummary].self, forKey: .items)
        items.append(objectsIn: decodeItems)
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    
    
    
}
@objcMembers class ComicSummary: Object,Decodable {
    
    dynamic var resourceURI :String = ""
    dynamic var name :String = ""
    
    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        resourceURI = try container.decode(String.self, forKey: .resourceURI)
        name = try container.decode(String.self, forKey: .name)
        
        
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}


@objcMembers class StoryList : Object, Decodable {
    
    
    
    let items = List<StorySummary>()
    
    
    enum CodingKeys: String, CodingKey {
        case items
        
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodeItems = try container.decode([StorySummary].self, forKey: .items)
        items.append(objectsIn: decodeItems)
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    
    
    
}
@objcMembers class StorySummary: Object,Decodable {
    
    dynamic var resourceURI :String = ""
    dynamic var name :String = ""
    
    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        resourceURI = try container.decode(String.self, forKey: .resourceURI)
        name = try container.decode(String.self, forKey: .name)
        
        
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}


@objcMembers class EventList : Object, Decodable {
    
    
    
    let items = List<EventSummary>()
    
    
    enum CodingKeys: String, CodingKey {
        case items
        
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodeItems = try container.decode([EventSummary].self, forKey: .items)
        items.append(objectsIn: decodeItems)
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    
    
    
}
@objcMembers class EventSummary: Object,Decodable {
    
    dynamic var resourceURI :String = ""
    dynamic var name :String = ""
    
    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        resourceURI = try container.decode(String.self, forKey: .resourceURI)
        name = try container.decode(String.self, forKey: .name)
        
        
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

@objcMembers class SeriesList : Object, Decodable {
    
    
    
    let items = List<SeriesSummary>()
    
    
    enum CodingKeys: String, CodingKey {
        case items
        
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodeItems = try container.decode([SeriesSummary].self, forKey: .items)
        items.append(objectsIn: decodeItems)
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    
    
    
}
@objcMembers class SeriesSummary: Object,Decodable {
    
    dynamic var resourceURI :String = ""
    dynamic var name :String = ""
    
    enum CodingKeys: String, CodingKey {
        case resourceURI
        case name
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        resourceURI = try container.decode(String.self, forKey: .resourceURI)
        name = try container.decode(String.self, forKey: .name)
        
        
        
        
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}




struct MarvelMovieResponse : Decodable {
    
    var code :Int
    var status :String
    var data : MarvelMovieResponseData
    
    enum CodingKeys: String, CodingKey {
        case code
        case status
        case data
        
    }
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decode(Int.self, forKey: .code)
        status = try container.decode(String.self, forKey: .status)
        data = try container.decode(MarvelMovieResponseData.self, forKey: .data)
        
    }
    
    
    
    
}

struct MarvelMovieResponseData : Decodable {
    
    let offset :Int
    let limit : Int
    let total : Int
    let count : Int
    let results : [MarvelMovie]
    
    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
        
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        offset = try container.decode(Int.self, forKey: .offset)
        limit = try container.decode(Int.self, forKey: .limit)
        total = try container.decode(Int.self, forKey: .total)
        count = try container.decode(Int.self, forKey: .count)
        
        results = try container.decode([MarvelMovie].self, forKey: .results)
        
    }
    
    
}
@objcMembers class MarvelMovie : Object, Decodable {
    
    dynamic var id : Int = 0
    dynamic var thumbnail :Thumbnail?
    
    

    
    enum CodingKeys: String, CodingKey {
        case id
        
        case thumbnail
        
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        id = try container.decode(Int.self, forKey: .id)
      
        thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
    
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
        
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
}
