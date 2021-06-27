
import UIKit

class WeatherViewController: UIViewController {
    
    private let weatherTableView = UITableView(frame: .zero, style: .plain)
    
    private var weatherReuseID: String {
        return String(describing: WeatherTableViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupTableView()
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
        return CityStorage.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherCell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: weatherReuseID, for: indexPath) as! WeatherTableViewCell
        
        let city = CityStorage.cities[indexPath.row]
        
        weatherCell.configure(with: city)
        
        return weatherCell
    }
    
    
}

