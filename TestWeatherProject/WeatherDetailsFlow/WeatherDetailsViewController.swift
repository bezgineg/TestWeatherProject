
import UIKit

class WeatherDetailsViewController: UIViewController {
    
    let weather: Weather
    
    private let weatherDetailsView: WeatherDetailsView = {
        let view = WeatherDetailsView()
        return view
    }()
    
    init(weather: Weather) {
        self.weather = weather
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = weather.name
        weatherDetailsView.configure(with: weather)
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubviews(weatherDetailsView)
        
        let constraints = [
            weatherDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}
