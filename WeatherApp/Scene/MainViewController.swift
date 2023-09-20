//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import UIKit
import SnapKit
import Combine

enum ErrorType {
    case server
    case connection
    
    var title: String {
        switch self {
        case .server:
            return "Error with server data"
        case .connection:
            return "No internet connection"
        }
    }
}

final class MainViewController: UIViewController {
    
    private lazy var presenter = MainPresenter(with: self,
                                               apiService: APIService(),
                                               locationService: LocationService(),
                                               persistanceService: PersistanceService())

    
    private let cachedLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        $0.isHidden = true
    }
    
    private let currentWeatherView = CurrentWeatherView()
    private let hourlyForecastView = HourlyForecastView()
    private let dailyForecastView = DailyForecastView()
    
    private let firstWidgetsStack = UIStackView().with {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }
    
    private let secondWidgetsStack = UIStackView().with {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }

    private let scrollView = UIScrollView()
    
    private var cancellables = Set<AnyCancellable>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.startTrackingLocation()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        contentView.addSubviews(cachedLabel, currentWeatherView, hourlyForecastView, dailyForecastView, firstWidgetsStack, secondWidgetsStack)
        
        cachedLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
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
        
        firstWidgetsStack.snp.makeConstraints {
            $0.top.equalTo(dailyForecastView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        secondWidgetsStack.snp.makeConstraints {
            $0.top.equalTo(firstWidgetsStack.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(contentView)
        }
    }
}

extension MainViewController: PresenterView {
    func displayError(type: ErrorType) {
        let alert = UIAlertController(title: "Error", message: type.title, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func displayWeather(_ allData: ForecastDomainModel, fromCache: Bool) {
        let first = allData.futureForecast.days.first
        let isCelsius = UnitTemperature.current == .celsius
        let currentWeatherInfo = CurrentWeatherViewInfo(
            locationName: allData.locationName ?? "Unknown location",
            temp: isCelsius ? allData.currentForecast.tempC : allData.currentForecast.tempF,
            minTemp: isCelsius ? first?.minTempC : first?.minTempF,
            maxTemp: isCelsius ? first?.maxTempC : first?.maxTempF,
            condition: allData.futureForecast.days.first?.condition ?? "")
        currentWeatherView.setup(with: currentWeatherInfo)
        
        
        let hourlyWeatherInfo = presenter.prepareHourlyData(
            data: allData.futureForecast.days,
            tzOffset: allData.tzOffset)
        hourlyForecastView.setup(with: hourlyWeatherInfo)
        
        let dailyWeathrInfo = presenter.prepareDailyData(
            data: allData.futureForecast.days,
            tzOffset: allData.tzOffset)
        dailyForecastView.setup(with: dailyWeathrInfo)
        
        if fromCache, let lastUpdate = allData.lastUpdated {
            cachedLabel.isHidden = false
            cachedLabel.text = "Last update at: \(lastUpdate.getFormattedDate())"
        } else {
            cachedLabel.isHidden = true
        }
        
        if let humidity = first?.hours.first?.humidity {
            let humidityWidget = WidgetView()
            humidityWidget.setup(with: .humidity, info: String(humidity))
            firstWidgetsStack.addArrangedSubview(humidityWidget)
        }
        
        if let feelC = first?.hours.first?.feelC,
           let feelF = first?.hours.first?.feelF {
            let feelWidget = WidgetView()
            feelWidget.setup(with: .feel(isMetric: isCelsius), info: String(isCelsius ? String(feelC) : String(feelF)))
            firstWidgetsStack.addArrangedSubview(feelWidget)
        }
        
        if let windKph = first?.hours.first?.windKPH,
           let windMph = first?.hours.first?.windMPH {
            let windWidget = WidgetView()
            windWidget.setup(with: .windSpeed(isMetric: isCelsius), info: String(isCelsius ? String(windKph) : String(windMph)))
            secondWidgetsStack.addArrangedSubview(windWidget)
        }
        
        if let visKM = first?.hours.first?.visKm,
           let visML = first?.hours.first?.visMiles {
            let visWidget = WidgetView()
            visWidget.setup(with: .visibility(isMetric: isCelsius), info: String(isCelsius ? String(visKM) : String(visML)))
            secondWidgetsStack.addArrangedSubview(visWidget)
        }
        
    }
}


extension Date {
   func getFormattedDate() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm"
        return dateformat.string(from: self)
    }
}

