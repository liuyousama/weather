//
//  ViewController.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
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
            self.setupInitialUI()
            self.requestCity()
            self.requestWeather()
        }
    }
    
    var bag = DisposeBag()
    var curWeatherVM = BehaviorRelay(value: CurrentWeatherViewModel.empty)
    var curLocationVM = BehaviorRelay(value: CurrentLocationViewModel.empty)
    var weekWeatherVM = BehaviorRelay(value: WeekWeatherViewModel.empty)
    
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
        self.setupInitialUI()
        self.requestLocation()
        self.setupUIBind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let res = WeatherApi.weatherDataAt(latitude: latitude, longitude: longitude).share(replay: 1, scope: .whileConnected)
        res.map {CurrentWeatherViewModel(weather: $0.currently)}.bind(to: curWeatherVM).disposed(by: bag)
        res.map {WeekWeatherViewModel(weathers: $0.daily)}.bind(to: weekWeatherVM).disposed(by: bag)
    }
    /// 在获取到定位后解析当前城市信息
    private func requestCity() {
        guard let location = currentLocation else {return}
        CLGeocoder().reverseGeocodeLocation(location) { [weak self](placemarks, error) in
            if let err = error {
                print(err)
                return
            }
            if let city = placemarks?.first?.locality {
                let loc = Location(name: city, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self?.curLocationVM.accept(CurrentLocationViewModel(location: loc))
            }
        }
    }
    
    private func setupUIBind() {
        
        let vm = Observable.combineLatest(curWeatherVM, curLocationVM, weekWeatherVM) {
            return ($0, $1, $2)
        }.filter {
            let (weatherVM, locationVM, weekVM) = $0
            return !weatherVM.isEmpty && !locationVM.isEmpty && !weekVM.isEmpty
        }.share(replay: 1, scope: .whileConnected).observeOn(MainScheduler.instance)
            
        vm.subscribe { _ in
            self.tableView.reloadData()
        }.disposed(by: bag)
            
        let driver = vm.asDriver(onErrorJustReturn: (CurrentWeatherViewModel.empty,                                             CurrentLocationViewModel.empty,
                                                      WeekWeatherViewModel.empty))
        driver.map {$0.1.city}.drive(cityName.rx.text).disposed(by: bag)
        driver.map {$0.0.temperature}.drive(currentTempure.rx.text).disposed(by: bag)
        driver.map {$0.0.humidity}.drive(currentHumidity.rx.text).disposed(by: bag)
        driver.map {$0.0.icon}.drive(currentWeatherIcon.rx.image).disposed(by: bag)
        driver.map {$0.0.time}.drive(currentTime.rx.text).disposed(by: bag)
        driver.map {$0.0.summary}.drive(currentWeatherSummary.rx.text).disposed(by: bag)
        driver.map {_ in false}.drive(loadingIndicator.rx.isAnimating).disposed(by: bag)
        driver.map {_ in false}.drive(currentWeatherContainer.rx.isHidden).disposed(by: bag)
        driver.map {_ in false}.drive(tableView.rx.isHidden).disposed(by: bag)
        driver.map {_ in true}.drive(errorText.rx.isHidden).disposed(by: bag)
        
    }
    
    private func setupInitialUI() {
        errorText.isHidden = true
        tableView.isHidden = true
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
        weekWeatherVM.accept(weekWeatherVM.value)
        curWeatherVM.accept(curWeatherVM.value)
        curLocationVM.accept(curLocationVM.value)
    }
    
    
}

