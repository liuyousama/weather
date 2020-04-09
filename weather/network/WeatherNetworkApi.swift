//
//  WeatherNetworkApi.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

struct WeatherApi {
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
    
    
}

protocol WeatherApiDelegate: AnyObject {
    func requestSuccess(weatherData: WeatherData)
    
    func requestError(error:Error)
    
    func handleDataError(error:Error)
    
    func receiveEmptyData()
}
