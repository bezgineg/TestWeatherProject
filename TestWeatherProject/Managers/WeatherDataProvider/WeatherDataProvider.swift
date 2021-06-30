
import Foundation
import CoreLocation

protocol WeatherDataProviderDelegate: class {
    func showNetworkAlert(_ weatherDataProvider: WeatherDataProvider,
                          withTitle title: String,
                          withMessage message: String)
}

class WeatherDataProvider {

    //MARK: - Public Properties
    weak var delegate: WeatherDataProviderDelegate?
 
    //MARK: - Public Methods
    private func fetchWeather(lat: String,
                      lon: String,
                      completion: @escaping (Result<Data,WeatherDataProviderError>) -> Void) {
        
        let urlString = "https://api.weather.yandex.ru/v2/forecast?lat=\(lat)&lon=\(lon)&limit=1&hours=false&extra=false"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.networkConnectionProblem))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("\(Constants.apiKey)", forHTTPHeaderField: "X-Yandex-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard error == nil else {
                completion(.failure(.networkConnectionProblem))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    //MARK: - Private Methods
    private func getCoordinates(city: String,
                        completion: @escaping (Result<CLLocationCoordinate2D, WeatherDataProviderError>) -> Void) {
        CLGeocoder().geocodeAddressString(city) { (placemark, error) in
            if let _ = error {
                completion(.failure(.networkConnectionProblem))
            }
            
            if let location = placemark?.first?.location {
                completion(.success(location.coordinate))
            } else {
                completion(.failure(.networkConnectionProblem))
            }
        }
    }
    
    func getWeather(cities: [String],
                    completion: @escaping (Int, Weather) -> Void) {
        for (index, city) in cities.enumerated() {
            getCoordinates(city: city) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                
                case .success(let location):
                    let lat = String(location.latitude)
                    let lon = String(location.longitude)
                    self.fetchWeather(lat: lat, lon: lon) { loadingResult in
                        switch loadingResult {
                        
                        case .success(let data):
                            let jsonDecoder = JSONDecoder()
                            if let dictionary = try? jsonDecoder.decode(WeatherData.self, from: data) {
                                let weather = Weather(name: city, temperature: dictionary.fact.temp, feelsLike: dictionary.fact.feelsLike, precType: dictionary.fact.precType, windSpeed: dictionary.fact.windSpeed, pressureMm: dictionary.fact.pressureMm, humidity: dictionary.fact.humidity, condition: dictionary.fact.condition)
                                completion(index, weather)
                            }
                        case .failure(let error):
                            switch error {
                            
                            case .networkConnectionProblem:
                                let title = "Проверьте интернет соединение"
                                let message = "Соединение с интернетом не установлено. Не удалось загрузить данные о погоде"
                                self.delegate?.showNetworkAlert(self, withTitle: title, withMessage: message)
                            }
                        }
                    }
                case .failure(let error):
                    switch error {
                    
                    case .networkConnectionProblem:
                        let title = "Проверьте интернет соединение"
                        let message = "Соединение с интернетом не установлено. Не удалось загрузить данные о погоде"
                        self.delegate?.showNetworkAlert(self, withTitle: title, withMessage: message)
                    }
                }
            }
        }
    }
}
