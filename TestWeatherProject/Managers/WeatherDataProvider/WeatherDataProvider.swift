
import Foundation
import CoreLocation

protocol WeatherDataProviderDelegate: class {
    func showNetworkAlert(with title: String, message: String)
}

class WeatherDataProvider {
    
    weak var delegate: WeatherDataProviderDelegate?
 
    func fetchWeather(lat: String, lon: String, completion: @escaping (Result<Data,WeatherDataProviderError>) -> Void) {
        
        let urlString = "https://api.weather.yandex.ru/v2/forecast?lat=\(lat)&lon=\(lon)&limit=1&hours=false&extra=false"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.networkConnectionProblem))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("\(Constants.apiKey)", forHTTPHeaderField: "X-Yandex-API-Key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard error == nil else {
                completion(.failure(.networkConnectionProblem))
                print(error.debugDescription)
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
            
        }
        task.resume()
    }
    
    func getCoordinates(city: String, completion: @escaping (Result<CLLocationCoordinate2D, WeatherDataProviderError>) -> Void) {
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
    
    func getWeather(city: String) {
        getCoordinates(city: city) { result in
            switch result {
            case .success(let location):
                let lat = String(location.latitude)
                let lon = String(location.longitude)
                self.fetchWeather(lat: lat, lon: lon) { loadingResult in
                    switch loadingResult {
                    case .success(let data):
                        let jsonDecoder = JSONDecoder()
                        if let dictionary = try? jsonDecoder.decode(WeatherData.self, from: data) {
                            let weather = Weather(name: city, temperature: dictionary.fact.temp, condition: dictionary.fact.condition)
                            WeatherStorage.weather.append(weather)
                        }
                    case .failure(let error):
                        switch error {
                        case .networkConnectionProblem:
                            let title = "Проверьте интернет соединение"
                            let message = "Соединение с интернетом не установлено. Не удалось загрузить данные о погоде"
                            self.delegate?.showNetworkAlert(with: title, message: message)
                        }
                    }
                }
            case .failure(let error):
                switch error {
                case .networkConnectionProblem:
                    let title = "Проверьте интернет соединение"
                    let message = "Соединение с интернетом не установлено. Не удалось загрузить данные о погоде"
                    self.delegate?.showNetworkAlert(with: title, message: message)
                }
            }
        }
    }
}
