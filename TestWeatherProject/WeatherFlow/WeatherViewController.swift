
import UIKit

class WeatherViewController: UIViewController {
    
    let weatherDataProvider: WeatherDataProvider
    
    private let weatherTableView = UITableView(frame: .zero, style: .plain)
    
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
        
        loadWeather()
        setupLayout()
        setupTableView()
    }
    
    private func loadWeather() {
        for city in CityStorage.cities {
            weatherDataProvider.getWeather(city: city)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.weatherTableView.reloadData()
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
        print(indexPath.row)
    }
}

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherStorage.weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherCell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: weatherReuseID, for: indexPath) as! WeatherTableViewCell
        
        let weather = WeatherStorage.weather[indexPath.row]
        
        weatherCell.configure(with: weather)
        
        return weatherCell
    }
    
    
}

