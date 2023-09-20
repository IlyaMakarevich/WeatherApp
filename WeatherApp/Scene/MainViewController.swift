//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import UIKit
import SnapKit
import Combine

final class MainViewController: UIViewController {
    
    private lazy var presenter = MainPresenter(with: self,
                                               apiService: APIService(),
                                               locationService: LocationService(), persistanceService: PersistanceService())
    
    private let reloadButton = UIButton().with {
        $0.setTitle("Reload", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
    }
    
    private let currentWeatherView = CurrentWeatherView()
    private let hourlyForecastView = HourlyForecastView()
    private let dailyForecastView = DailyForecastView()

    private let scrollView = UIScrollView()
    
    private var cancellables = Set<AnyCancellable>()
    
//    private let hourlyCollectionView = UICollectionView()
//    private lazy var source = CustomCollection.GridSource(container: hourlyCollectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.startTrackingLocation()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        
        scrollView.pinTo(view)
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(1500)
        }
        
        contentView.addSubviews(reloadButton, currentWeatherView, hourlyForecastView, dailyForecastView)
        reloadButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(15)
        }
        currentWeatherView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }
        
        hourlyForecastView.snp.makeConstraints {
            $0.top.equalTo(currentWeatherView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dailyForecastView.snp.makeConstraints {
            $0.top.equalTo(hourlyForecastView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bindUI() {
        reloadButton.tapPublisher()
            .sink { [weak self] in self?.presenter.forceUpdateLocation()}
            .store(in: &cancellables)
    }
}

extension MainViewController: PresenterView {
    func displayError() {
        let alert = UIAlertController(title: "Error", message: "Something wen wrong", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func displayWeather(_ allData: ForecastDomainModel) {
        currentWeatherView.setup(with: allData)
        hourlyForecastView.setup(with: allData.futureForecast.days,
                                 tzOffset: allData.tzOffset)
    }
}

