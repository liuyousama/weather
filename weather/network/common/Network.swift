//
//  Network.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

class Network {
    enum NetworkMethod:String {
        case get = "GET"
        case post = "POST"
    }
    
    typealias ClosureType = ((Data?,URLResponse?,Error?)->Void)
    
    static func request(_ url:String, method: NetworkMethod, params:[String:Any]=[:], closure:@escaping ClosureType) {
        let manager = NetworkManager(urlStr:url, method:method.rawValue, params:params, callback:closure)
        manager.fire()
    }
    
    static func get(_ url:String, params:[String:Any]=[:], closure:@escaping ClosureType) {
        let manager = NetworkManager(urlStr: url, method: "GET", params: params, callback: closure)
        manager.fire()
    }
    
    static func post(_ url:String, params:[String:Any]=[:], closure:@escaping ClosureType) {
        let manager = NetworkManager(urlStr: url, method: "POST", params: params, callback: closure)
        manager.fire()
    }
}
