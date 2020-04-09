//
//  NetworkManager.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

class NetworkManager {
    let method: String
    let params: [String: Any]
    let urlStr:String
    let callback: (Data?, URLResponse?, Error?)->Void
    
    let files:[NetworkFile]
    let formBoundary = "LiuYouU2Sb4DAn"
    
    let session = URLSession.shared
    var request:URLRequest!
    var task:URLSessionTask!
    
    enum NetworkError: Error {
        case BadUrl
        case HttpBodyBuildError
        case FormFileReadFail
    }
    
    init(urlStr:String, method:String, params:[String:Any]=[:], callback:@escaping(Data?,URLResponse?,Error?)->Void, files:[NetworkFile]=[]) {
        self.urlStr = urlStr
        self.params = params
        self.callback = callback
        self.method = method
        self.files = files
    }
    
    func buildRequest() -> Bool {
        //根据请求方式和参数拼接URL
        var newUrlStr = urlStr
        if method == "GET" && !params.isEmpty {
            newUrlStr = newUrlStr + "?" + NetworkTool.buildParams(params: params)
        }
        //生成URL对象
        guard let url = URL(string: newUrlStr) else {
            self.callback(nil, nil, NetworkError.BadUrl)
            return false
        }
        
        //生成request对象
        self.request = URLRequest(url: url)
        if method != "GET" && !files.isEmpty {
            self.request.addValue("multipart/form-data;boundary=\(formBoundary)", forHTTPHeaderField: "Content-Type")
        } else if method != "GET" && !params.isEmpty {
            self.request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        return true
    }
    
    func buildBody() -> Bool {
        var data = Data()
        if !files.isEmpty {
            if method == "GET" {
                print("\nYou're uploading files using GET HTTP method, remote server may not accept your file data, but LYNetwork will still send it\n")
            }
            guard let boundaryHeadData="--\(formBoundary)\r\n".data(using: .utf8),
            let boundaryTileData="--\(formBoundary)--\r\n".data(using: .utf8),
            let breakLineData="\r\n".data(using: .utf8) else {
                callback(nil, nil, NetworkError.HttpBodyBuildError)
                return false
            }
            for (key, value) in params {
                guard let keyData="Content-Diposition: form-data;name=\"\(key)\"\r\n\r\n".data(using: .utf8),
                let valueData="\(value)\r\n".data(using: .utf8) else {
                    callback(nil, nil, NetworkError.HttpBodyBuildError)
                    return false
                }
                data.append(boundaryHeadData)
                data.append(keyData)
                data.append(valueData)
            }
            for file in files {
                guard let keyData = "Content-Disposition: form-data;name=\"\(file.name)\"; filename=\"\(file.url.lastPathComponent)\"\r\n\r\n".data(using: .utf8),
                let valueData = try?Data(contentsOf: file.url) else {
                    callback(nil, nil, NetworkError.FormFileReadFail)
                    return false
                }
                data.append(boundaryHeadData)
                data.append(keyData)
                data.append(valueData)
                data.append(breakLineData)
            }
            data.append(boundaryTileData)
        } else if method != "GET" && !params.isEmpty {
            guard let normalData=NetworkTool.buildParams(params: params).data(using: .utf8) else {
                callback(nil, nil, NetworkError.HttpBodyBuildError)
                return false
            }
            self.request.httpBody = normalData
        }
        
        return true
    }
    
    func fireTast() {
        self.task = self.session.dataTask(with: self.request, completionHandler: self.callback)
        self.task.resume()
    }
    
    func fire() {
        guard self.buildRequest() else { return }
        guard self.buildBody() else { return }
        self.fireTast()
    }
}
