
import UIKit

class WeatherViewController: UIViewController {

    let weatherDataProvider: WeatherDataProvider
    
    private let weatherTableView = UITableView(frame: .zero, style: .plain)
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var weatherReuseID: String {
        return String(describing: WeatherTableViewCell.self)
    }
    
    init(weatherDataProvider: WeatherDataProvider) {
        self.weatherDataProvider = weatherDataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherDataProvider.delegate = self
        loadWeather()
        setupLayout()
        setupTableView()
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Найти"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func loadWeather() {
        if WeatherStorage.weather.isEmpty {
            WeatherStorage.weather = Array(repeating: Weather(), count: CityStorage.cities.count)
        }
        weatherDataProvider.getWeather(cities: CityStorage.cities) { index, weather in
            WeatherStorage.weather[index] = weather
            
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
           
        }
        
        
    }
    
    private func setupTableView() {
        weatherTableView.backgroundColor = .white
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: weatherReuseID)
    }
    
    private func setupLayout() {
        view.addSubviews(weatherTableView)
        
        let constraints = [
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering {
            let weather = FilteredWeatherStorage.weather[indexPath.row]
            let weatherDetailsViewController = WeatherDetailsViewController(weather: weather)
            navigationController?.pushViewController(weatherDetailsViewController, animated: true)
        } else {
            let weather = WeatherStorage.weather[indexPath.row]
            let weatherDetailsViewController = WeatherDetailsViewController(weather: weather)
            navigationController?.pushViewController(weatherDetailsViewController, animated: true)
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return FilteredWeatherStorage.weather.count
        } else {
            return WeatherStorage.weather.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherCell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: weatherReuseID, for: indexPath) as! WeatherTableViewCell
        
        if isFiltering {
            let weather = FilteredWeatherStorage.weather[indexPath.row]
            weatherCell.configure(with: weather)
            return weatherCell
        } else {
            let weather = WeatherStorage.weather[indexPath.row]
            weatherCell.configure(with: weather)
            return weatherCell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: "Удалить") {_,_,_ in
            
            let city = WeatherStorage.weather[indexPath.row]
            
            if let index = WeatherStorage.weather.firstIndex(of: city) {
                if self.isFiltering {
                    FilteredWeatherStorage.weather.remove(at: index)
                    self.weatherTableView.performBatchUpdates {
                        self.weatherTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    WeatherStorage.weather.remove(at: index)
                    self.weatherTableView.performBatchUpdates {
                        self.weatherTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
    
}

extension WeatherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterWeatherStorage(with: text)
    }
    
    private func filterWeatherStorage(with text: String) {
        FilteredWeatherStorage.weather = WeatherStorage.weather.filter {
            $0.name.contains(text)
        }
        weatherTableView.reloadData()
    }
}

extension WeatherViewController: WeatherDataProviderDelegate {
    func showNetworkAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: false, completion: nil)
    }
}



