
import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: - Public Properties
    let weatherDataProvider: WeatherDataProvider
    
    //MARK: - Private Properties
    private let weatherTableView = UITableView(frame: .zero, style: .plain)
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    private var weatherReuseID: String {
        return String(describing: WeatherTableViewCell.self)
    }
    
    //MARK: - Initializers
    init(weatherDataProvider: WeatherDataProvider) {
        self.weatherDataProvider = weatherDataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appointDelegates()
        loadWeather()
        setupTableView()
        setupSearchController()
    }
    
    override func loadView() {
        view = weatherTableView
    }
    
    //MARK: - Private Methods
    private func appointDelegates() {
        weatherDataProvider.delegate = self
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
        weatherDataProvider.getWeather(cities: CityStorage.cities) { [weak self] index, weather in
            guard let self = self else { return }
            WeatherStorage.weather.append(weather)
            
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
}

// MARK: - UITableViewDelegate
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

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
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
        let removeAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _,_,_ in
            guard let self = self else { return }
            
            let city = WeatherStorage.weather[indexPath.row]
            
            if let index = WeatherStorage.weather.firstIndex(of: city) {
                if self.isFiltering {
                    let newCity = FilteredWeatherStorage.weather[index]
                    FilteredWeatherStorage.weather.remove(at: index)
                    if let weatherStorageCityIndex = WeatherStorage.weather.firstIndex(of: newCity) {
                        WeatherStorage.weather.remove(at: weatherStorageCityIndex) }
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

// MARK: - UISearchResultsUpdating
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

// MARK: - WeatherDataProviderDelegate
extension WeatherViewController: WeatherDataProviderDelegate {
    func showNetworkAlert(_ weatherDataProvider: WeatherDataProvider, withTitle title: String, withMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: false, completion: nil)
    }
}



