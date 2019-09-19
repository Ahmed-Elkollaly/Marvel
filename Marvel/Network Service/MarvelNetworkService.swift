//
//  MarvelNetworkService.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/2/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation


enum NetworkResponse :String {
    
    case urlIsNil
    case success
    case errorStatusCode
    case errorNetworkExists
    case dataIsNilFromRequest
    
    
    
}

/// The role of this class to construct
class MarvelNetworkService {
    
    
    
    var endPoint : ApiEndPointProtocol
    
    private let network : NetworkRouter
    
    init(endPoint:ApiEndPointProtocol) {
        
        self.endPoint = endPoint
        self.network = NetworkRouter()
    }
    
    func fetchData(completionHandler: @escaping ((NetworkResponse,Data?)) -> Void ){
        
        guard let url = constructURL(endPoint: endPoint) else { return completionHandler((.urlIsNil,nil)) }
        
        async {
            
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.network.requestData(url: url) { (data,response,error) in
                
                guard (error == nil) else{
                    print("error: \(String(describing: error))")
                    return completionHandler( (.errorNetworkExists,nil))
                }
                
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                    
                    return completionHandler( (.errorStatusCode,nil))
                }
                
                guard let data = data else { return completionHandler( (.dataIsNilFromRequest,nil)) }
                
                
                completionHandler((.success,data))
                
                
                
            }
            
            
        }
        
    }
    func constructURL(endPoint:ApiEndPointProtocol) -> URL? {
        
        guard let baseURl = endPoint.baseURL else  { return nil }

        let url = baseURl.appendingPathComponent(endPoint.path)
        
        
        var component = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        component?.queryItems = endPoint.parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
        
        
        
        return component?.url
        
        
    }
    
}
