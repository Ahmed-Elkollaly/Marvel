//
//  ServiceProtocol.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/2/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation


typealias Parameters = [String: Any]



/// Define HTTPMethod Type
enum HTTPMethod :String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "Delete"
}

/// Protocol for Generic EndPoint
protocol ApiEndPointProtocol {
    
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    
    
}
