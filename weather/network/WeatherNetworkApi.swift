//
//  WeatherNetworkApi.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherApi {
    static let session = URLSession.shared
    
    static func requestWeatherDataWithDelegate(latitude: Double, longitude: Double, delegate: WeatherApiDelegate) -> Void {
        let url = DarkskyUrl.appendingPathComponent("\(latitude),\(longitude)")
        
        Network.get(url.absoluteString) { [weak delegate](data, response, err) in
            if let err = err { delegate?.requestError(error: err); return}
            guard let data = data else {delegate?.receiveEmptyData(); return}
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                delegate?.requestSuccess(weatherData: weatherData)
            } catch {
                delegate?.handleDataError(error: error)
                return
            }
        }
        
    }
    static func weatherDataAt(latitude: Double, longitude: Double) -> Observable<WeatherData> {
        let url = DarkskyUrl.appendingPathComponent("\(latitude),\(longitude)")
        var request = URLRequest(url:url)
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        return self.session.rx
        .data(request: request).map {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            return try decoder.decode(WeatherData.self, from: $0)
        }
    }
    
}

protocol WeatherApiDelegate: AnyObject {
    func requestSuccess(weatherData: WeatherData)
    
    func requestError(error:Error)
    
    func handleDataError(error:Error)
    
    func receiveEmptyData()
}
