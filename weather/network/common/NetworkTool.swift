//
//  NetworkToll.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

class NetworkTool {
    static func escape(str: String) -> String {
        str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    static func queryComponents(key: String, value: Any) -> [(String, String)] {
        var components = [(String, String)]()
        if let dict = value as? [String:Any] {
            for (nestedKey, val) in dict {
                components += queryComponents(key: "\(key)[\(nestedKey)]", value: val)
            }
        } else if let arr = value as? [Any] {
            for val in arr {
                components += queryComponents(key: "\(key)", value: val)
            }
        } else {
            components.append((escape(str: key), escape(str: "\(value)")))
        }
        return [("", "")]
    }
    
    static func buildParams(params: [String: Any]) -> String {
        var components = [(String, String)]()
        for key in params.keys.sorted(by: <) {
            components += self.queryComponents(key: key, value: params[key]!)
        }
        
        return components.map {"\($0)=\($1)"}.joined(separator: "&")
    }
}
