//
//  Respository.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/3/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation


protocol Respository {
    
    associatedtype T
    
    func getAll(_ completionHandler: @escaping (([T]) -> Void) )
    func getCharacters(withNameStartsWith name: String, _ completionHandler: @escaping (([T]) -> Void)) 
    
}


