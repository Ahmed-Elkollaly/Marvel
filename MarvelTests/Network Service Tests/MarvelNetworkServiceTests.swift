//
//  MarvelNetworkService.swift
//  MarvelTests
//
//  Created by Ahmed El-Kollaly on 9/2/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import XCTest

@testable import Marvel


/// Testing class for MarvelNetworkService class.
/// The followed naming convention for the tests' methods is test_methodName_withCertainState_shouldDoSomething
class MarvelNetworkServiceTests: XCTestCase {

    var marvelNetworkService:MarvelNetworkService?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let marvelEndPoint = MarvelApiEndPoint.allCharacters
        
        marvelNetworkService = MarvelNetworkService(endPoint: marvelEndPoint)
        
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        marvelNetworkService = nil
    }
    
 
    /// Test constructURL for url existance
    func test_constructURL_forMarvelEndPointAllCharacters_expectURLNotNil() {
        
        
        XCTAssertNotNil(marvelNetworkService?.constructURL(endPoint: MarvelApiEndPoint.allCharacters))
        
    }
    
    
    // TODO:  Mock URL Session and call fake data
    func test_fetchData_forMarvelCharacter_expectSuccessResponse() {
        
        if isConnectedToNetwork {
            
            
            let fetchDataExpectation = expectation(description: "Success")
            
           
            var networkResponse = NetworkResponse.errorNetworkExists
            
            marvelNetworkService?.fetchData(completionHandler: { (arg0) in
                
                let (response, _) = arg0
                
                networkResponse = response
                
                fetchDataExpectation.fulfill()
            })
            
            waitForExpectations(timeout: 5, handler: nil)
            
            
            XCTAssert(networkResponse == .success)
            
            
        }
        
        
        
        
        
        
    }

}
