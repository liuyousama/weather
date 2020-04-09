//
//  ViewController.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit
import CoreLocation

class InitialViewController: UIViewController {
    // MARK: - 属性
    private lazy var locationManager:CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        return manager
    }()
    private var currentLocation:CLLocation? {
        didSet {
            self.requestCity()
        }
    }
    var locationData:Location? {
        willSet {
            guard let location = newValue else {return}
            self.cityName.text = location.name
            self.requestWeather()
        }
    }
    var weatherData:WeatherData? {
        willSet {
            DispatchQueue.main.async {
                self.willReceiveWeatherData(data: newValue)
            }
        }
    }
    
    // MARK: - UI相关的属性
    @IBOutlet weak var currentWeatherContainer: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentWeatherSummary: UILabel!
    @IBOutlet weak var currentTempure: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorText: UILabel!
    @IBAction func clickedLocBtn(_ sender: UIButton) {pressedLocationBtn(btn: sender)}
    @IBAction func clickedSettingBtn(_ sender: UIButton) {pressedSettingBtn(btn: sender)}
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupInitialUI()
        self.requestLocation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - 网络代理
extension InitialViewController: WeatherApiDelegate {
    func requestSuccess(weatherData: WeatherData) {
        self.weatherData = weatherData
    }
    
    func requestError(error: Error) {
        print(error)
        loadingIndicator.stopAnimating()
        errorText.isHidden = false
    }
    
    func handleDataError(error: Error) {
        print(error)
        loadingIndicator.stopAnimating()
        errorText.isHidden = false
    }
    
    func receiveEmptyData() {
        print(#function)
    }
    
    
}

// MARK: - CLLocation 定位的代理
extension InitialViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            locationManager.delegate = nil
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.requestLocation()
        } else {
            //TODO 提示用户，需要权限
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
    
}

// MARK: - 响应函数
extension InitialViewController {
    func pressedLocationBtn(btn:UIButton) {
        print(#function)
    }
    
    func pressedSettingBtn(btn:UIButton) {
        print(#function)
    }
    
}

// MARK: - 私有方法
extension InitialViewController {
    /// 进入界面的时候开始请求位置信息
    private func requestLocation() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.locationManager.requestLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    /// 在获取到定位后请求天气信息
    private func requestWeather() {
        guard let location = currentLocation else {return}
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        WeatherApi.requestWeatherDataWithDelegate(latitude: latitude, longitude: longitude, delegate: self)
    }
    /// 在获取到定位后解析当前城市信息
    private func requestCity() {
        guard let location = currentLocation else {return}
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let err = error {
                print(err)
                dump(err)
                return
            }
            if let city = placemarks?.first?.locality {
                self.locationData = Location(name: city, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    private func setupInitialUI() {
        errorText.isHidden = true
        currentWeatherContainer.isHidden = true
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func willReceiveWeatherData(data:WeatherData?) {
        guard let data = data else {return}
        errorText.isHidden = true
        currentWeatherContainer.isHidden = false
        loadingIndicator.stopAnimating()
        //更新现在的天气
        let current = data.currently
        currentWeatherIcon.image = UIImage.getWeatherIcon(withIconName: current.icon)
        currentWeatherSummary.text = current.summary
        currentTempure.text = current.temperature.toCelsiusStr()
        currentHumidity.text = current.humidity.toHumiditStr()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        currentTime.text = formatter.string(from: current.time)
    }
    
    
}

