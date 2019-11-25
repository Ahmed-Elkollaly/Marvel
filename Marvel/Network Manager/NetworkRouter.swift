//
//  NetworkRouter.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/3/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation


typealias NetworkRequestResult = (((Data?, URLResponse?, Error?)) -> Void)


class NetworkRouter {
    
    
    func requestData(url :URL, _ requestResult : @escaping NetworkRequestResult) {
    
        let session = URLSession.shared
//        print("URL: \(url)")
        let request = URLRequest(url: url)
    
        let task = session.dataTask(with: request){
            (data,response,error) in
            
            print("Networking...")
            requestResult((data,response,error))
            
        }
        
        task.resume()
            
        
        
    }
    
    
    
}
