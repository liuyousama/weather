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
            self.requestWeather()
        }
    }
    var currentWeatherViewModel:CurrentWeatherViewModel {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    var weekWeatherViewModel:WeekWeatherViewModel {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
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
    @IBOutlet weak var tableView: UITableView!
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
    // MARK: - 初始化方法
    required init?(coder: NSCoder) {
        currentWeatherViewModel = CurrentWeatherViewModel()
        weekWeatherViewModel = WeekWeatherViewModel()
        super.init(coder: coder)
    }
}

// MARK: - 网络代理
extension InitialViewController: WeatherApiDelegate {
    func requestSuccess(weatherData: WeatherData) {
        currentWeatherViewModel.currentWeatherData = weatherData.currently
        weekWeatherViewModel.weekWeatherData = weatherData.daily
    }
    
    func requestError(error: Error) {
        DispatchQueue.main.async {
            self.showErrorInfo()
        }
    }
    
    func handleDataError(error: Error) {
        DispatchQueue.main.async {
            self.showErrorInfo()
        }
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

// MARK: - SettingController的代理
extension InitialViewController: SettingControllerDelegate {
    func didChangeTimeMode() {
        updateUI()
    }
    
    func didChangeTemperatureMode() {
        updateUI()
    }
    
    
}

// MARK: - LocationManagerController的代理
extension InitialViewController: LocationManagerControllerDelegate {
    func controller(_ controller: LocationManagerController, didSelectLocation location: CLLocation) {
        currentLocation = location
    }
    
    
}

// MARK: - 响应函数
extension InitialViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToSettingController", let destVc = segue.destination as? SettingViewController {
            destVc.delegate = self
            destVc.modalPresentationStyle = .fullScreen
        }
        if segue.identifier == "GoToLocationManager", let destVc = segue.destination as? LocationManagerController {
            destVc.currentLocation = currentLocation
            destVc.delegate = self
            destVc.modalPresentationStyle = .fullScreen
        }
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
                return
            }
            if let city = placemarks?.first?.locality {
                self.currentWeatherViewModel.locationData =
                    Location(name: city, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    private func setupInitialUI() {
        errorText.isHidden = true
        tableView.isHidden = false
        currentWeatherContainer.isHidden = true
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func showErrorInfo() {
        errorText.isHidden = false
        currentWeatherContainer.isHidden = true
        tableView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    private func updateUI() {
        let vm1 = currentWeatherViewModel
        let vm2 = weekWeatherViewModel
        
        if vm1.dataIsReady {
            currentWeatherIcon.image = vm1.icon
            currentWeatherSummary.text = vm1.summary
            currentTime.text = vm1.time
            currentTempure.text = vm1.temperature
            currentHumidity.text = vm1.humidity
            cityName.text = vm1.cityName
            errorText.isHidden = true
            loadingIndicator.stopAnimating()
            currentWeatherContainer.isHidden = false
        }
        
        if vm2.isDataReady {
            tableView.isHidden = false
            tableView.reloadData()
        }
        
    }
    
    
}

