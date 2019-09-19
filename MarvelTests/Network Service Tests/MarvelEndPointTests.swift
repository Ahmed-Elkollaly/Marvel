//
//  MarvelEndPointTests.swift
//  MarvelTests
//
//  Created by Ahmed El-Kollaly on 9/6/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import XCTest

@testable import Marvel

class MarvelEndPointTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_marvelEndPointAllCharacters_shouldBaseURLIsCorrect(){
        
        
        let all = MarvelApiEndPoint.allCharacters
        
        
        
        
        if let baseURL = URL(string: "https://gateway.marvel.com/v1/public/"){
            
            
            XCTAssertEqual(all.baseURL, baseURL)
        
        }
        
    }
    func test_marvelEndPointAllCharacters_shouldPathIsCorrect(){
        
        
        let all = MarvelApiEndPoint.allCharacters
        
        
        XCTAssertEqual(all.path, "characters")
        
        
        
        
    }

}
